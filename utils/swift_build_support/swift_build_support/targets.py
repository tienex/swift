# swift_build_support/targets.py - Build target helpers -*- python -*-
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors

import platform


def host_target():
    """
    Return the build target for the current host machine, if it is one of the
    recognized targets. Otherwise, return None.
    """
    system = platform.system()
    machine = platform.machine()

    if system == 'Linux':
        if machine == 'x86_64':
            return 'linux-x86_64'
        elif machine.startswith('armv7'):
            # linux-armv7* is canonicalized to 'linux-armv7'
            return 'linux-armv7'
        elif machine == 'aarch64':
            return 'linux-aarch64'
        elif machine == 'ppc64':
            return 'linux-powerpc64'
        elif machine == 'ppc64le':
            return 'linux-powerpc64le'

    elif system == 'Darwin':
        if machine == 'x86_64':
            return 'macosx-x86_64'

    elif system == 'FreeBSD':
        if machine == 'amd64':
            return 'freebsd-x86_64'

    return None
