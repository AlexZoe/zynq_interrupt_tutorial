/*------------------------------------------------------------------------------
#
#  @author	Alexander Zoellner
#  @date	2019/07/21
#  @mail	zoellner.contact<at>gmail.com
#  @file	hw_timer.c
#
#  @brief	Kernel device driver for PL hardware timer module.
#
#-----------------------------------------------------------------------------*/

#include <linux/interrupt.h>
#include <linux/module.h>
#include <linux/device.h>
#include <linux/of_irq.h>
#include <linux/errno.h>
#include <linux/cdev.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/mm.h>
#include <linux/io.h>
#include <linux/of.h>

MODULE_AUTHOR("Alexander Zoellner");
MODULE_LICENSE("GPL");

static struct cdev cdev;
static struct class *cl;
static dev_t dev;

static u32 __iomem *region_virt_start_addr;
// intr 91:84 68:61 => intr[16:0]
static u32 timer_irq;

enum TIMER_CMDS {
	TIMER_CFG = 0,
	TIMER_START = 1,
	TIMER_STOP = 2,
	TIMER_DEBUG = 3
};

#define HW_START_ADDR	0x43C00000
#define HW_ADDR_SIZE	(64*1024) // size in kByte

#define LOAD_VAL	10000

#define HW_CTRL_REG_OFF	0
#define HW_LOAD_REG_OFF	1

#define START_BIT_OFFSET	BIT(0)
#define AUTO_RELOAD_BIT_OFFSET	BIT(1)


static irqreturn_t timer_intr_handler(int irq, void *dev)
{
	pr_info("timer intr occured\n");
	return IRQ_HANDLED;
}



static int timer_open(struct inode *dev_file, struct file *filp)
{
	pr_info("Open timer\n");
	return 0;
}


static long timer_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	switch (cmd) {
	case TIMER_CFG:
		pr_info("Load cfg\n");
		iowrite32(LOAD_VAL, region_virt_start_addr + HW_LOAD_REG_OFF);
		break;
	case TIMER_START:
		pr_info("Start timer\n");
		iowrite32(START_BIT_OFFSET,
			  region_virt_start_addr + HW_CTRL_REG_OFF);
		break;
	case TIMER_STOP:
		pr_info("Stop timer\n");
		iowrite32(0, region_virt_start_addr + HW_CTRL_REG_OFF);
		break;
	case TIMER_DEBUG:
		pr_info("Loaded val: %i\n",
			ioread32(region_virt_start_addr + HW_LOAD_REG_OFF));
		break;
	default:
		break;
	}
	return 0;
}



static int timer_close(struct inode *dev_file, struct file *filp)
{
	pr_info("Close timer\n");
	return 0;
}



static const struct file_operations timer_fops = {
	.owner = THIS_MODULE,
	.open = timer_open,
	.unlocked_ioctl = timer_ioctl,
	.release = timer_close,
};

static int __init mod_init(void)
{
	struct device_node *np;
	struct device *device;
	int ret;

	np = of_find_node_by_name(NULL, "hw_timer_0");
	timer_irq = irq_of_parse_and_map(np, 0);

	if (request_irq(timer_irq, &timer_intr_handler, 0,
			"hw_timer_intr", NULL)) {
		pr_info("hw timer: cannot obtain irq number\n");
		return -1;
	}

	if (!(request_mem_region(HW_START_ADDR, HW_ADDR_SIZE,
		     "hw_timer_region"))) {
		ret = -1;
		goto unregister_irq;
	}

	region_virt_start_addr = ioremap(HW_START_ADDR, HW_ADDR_SIZE);
	if (!region_virt_start_addr) {
		ret = -1;
		goto release_region;
	}

	if (alloc_chrdev_region(&dev, 0, 1, "timer_mod") < 0) {
		ret = -1;
		goto unmap_region;
	}

	cdev_init(&cdev, &timer_fops);
	ret = cdev_add(&cdev, dev, 1);
	if (ret < 0)
		goto unregister_chrdev;

	cl = class_create(THIS_MODULE, "timer_mod");
	if (!cl) {
		ret = -1;
		goto clear_cdev;
	}

	device = device_create(cl, NULL, MKDEV(MAJOR(dev), MINOR(dev)), NULL,
				"timer_dev");
	if (IS_ERR(device)) {
		ret = -1;
		goto clear_class;
	}

	return 0;

clear_class:
	class_destroy(cl);
clear_cdev:
	cdev_del(&cdev);
unregister_chrdev:
	unregister_chrdev_region(dev, 1);
unmap_region:
	iounmap(region_virt_start_addr);
release_region:
	release_mem_region(HW_START_ADDR, HW_ADDR_SIZE);
unregister_irq:
	free_irq(timer_irq, NULL);
	return ret;
}

static void __exit mod_exit(void)
{
	free_irq(timer_irq, NULL);
	device_destroy(cl, MKDEV(MAJOR(dev), MINOR(dev)));
	class_destroy(cl);
	cdev_del(&cdev);
	unregister_chrdev_region(dev, 1);
	iounmap(region_virt_start_addr);
	release_mem_region(HW_START_ADDR, HW_ADDR_SIZE);
}

module_init(mod_init);
module_exit(mod_exit);
