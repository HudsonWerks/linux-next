#!/bin/sh -e
#
# Copyright (c) 2009-2014 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

#yeah, i'm getting lazy..

DIR=$PWD

repo="git@github.com:RobertCNelson/linux-stable-rcn-ee.git"
example="rcn-ee"

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	. ${DIR}/version.sh

	git commit -a -m "${KERNEL_TAG}-${BUILD} release" -s
	git tag -a "${KERNEL_TAG}-${BUILD}" -m "${KERNEL_TAG}-${BUILD}"

	git push origin ${BRANCH}
	git push origin ${BRANCH} --tags

	cd ${DIR}/KERNEL/
	make ARCH=arm distclean

	cp ${DIR}/patches/defconfig ${DIR}/KERNEL/arch/arm/configs/${example}_defconfig
	git add arch/arm/configs/${example}_defconfig

	git commit -a -m "${KERNEL_TAG}-${BUILD} ${example}_defconfig" -s
	git tag -a "${KERNEL_TAG}-${BUILD}" -m "${KERNEL_TAG}-${BUILD}"

	#push tag
	git push -f ${repo} "${KERNEL_TAG}-${BUILD}"

	cd ${DIR}/
fi

