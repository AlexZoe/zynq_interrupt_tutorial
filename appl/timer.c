/*------------------------------------------------------------------------------
#
#  @author	Alexander Zoellner
#  @date	2019/07/21
#  @mail	zoellner.contact<at>gmail.com
#  @file	Makefile
#
#  @brief	Makefile for building Linux user space application for
#		demonstrating interrupts.
#
#-----------------------------------------------------------------------------*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>

enum TIMER_CMDS {
        TIMER_CFG = 0,
        TIMER_START = 1,
        TIMER_STOP = 2,
        TIMER_DEBUG = 3
};

int main(int argc, char* argv[])
{
        int fs;

        fs = open("/dev/timer_dev", O_RDONLY);
	if (fs < 0)
		return -1;

        // Configure timer
        ioctl(fs, TIMER_CFG, NULL);

        // Check if timer has been configured (dmesg)
        ioctl(fs, TIMER_DEBUG, NULL);

	// Start timer
	ioctl(fs, TIMER_START, NULL);

        close(fs);

        return 0;
}
