# Copyright (C) 2019, ATA Engineering, Inc.
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.


# Set CHEM_BASE to point to the CHEM installation directory to compile
# this module
#
# To use a module, compile the module and then put the resulting shared object
# file either in the installed lib directory with chem or some other place that
# is contained in the LD_LIBRARY_PATH.  Once this is done, the module can be
# by placing 'loadModule: MODULE_NAME' into the top of the vars file
#
# Makefile SETUP:
# Set CHEM_BASE to the directory where CHEM is installed
# Set MODULE_NAME to the name of your module
# Set OBJS to list '.o' files that will be compiled into your module

LOCI_BASE?=/usr/local/loci
CHEM_BASE?=/usr/local/chem

MODULE_NAME = sponge

# Put objects in the module here
LOCI_OBJS = chemInterface.o sponge.o distance.o
OBJS =

###########################################################################
# No changes required below this line
###########################################################################
include $(CHEM_BASE)/chem.conf
include $(LOCI_BASE)/Loci.conf

INCLUDES = -I$(CHEM_BASE)/include -I$(CHEM_BASE)/include/fluidPhysics
#uncomment this for a debugging compile
#COPT=-O0 -g 
CPP += -fPIC

LOCAL_LIBS = 

JUNK = *~  core ti_files ii_files rii_files

LIB_OBJS=$(LOCI_OBJS:.o=_lo.o)

all: $(MODULE_NAME)_m.so DOCS

$(MODULE_NAME)_m.so: $(LIB_OBJS) $(OBJS)
	$(SHARED_LD) $(SHARED_LD_FLAGS) $(MODULE_NAME)_m.so $(LIB_FLAGS) $(LIB_OBJS) $(OBJS)

DOCS: 
	$(MAKE) -C userGuide all

FRC : 

clean:
	rm -fr $(LOCI_OBJS) $(OBJS) $(LIB_OBJS) $(MODULE_NAME)_m.so $(JUNK)
	$(MAKE) -C userGuide clean

install: $(MODULE_NAME)_m.so
	cp $(MODULE_NAME)_m.so $(CHEM_BASE)/lib

LOCI_FILES = $(wildcard *.loci)
LOCI_LPP_FILES = $(LOCI_FILES:.loci=.cc)

distclean: 
	rm $(DEPEND_FILES)
	rm -fr $(LOCI_OBJS) $(OBJS) $(LIB_OBJS) $(MODULE_NAME)_m.so $(JUNK) $(LOCI_LPP_FILES)
	$(MAKE) -C userGuide clean

# dependencies
#
%.d: %.cpp
	set -e; $(CPP) -M $(COPT) $(EXCEPTIONS) $(DEFINES) $(INCLUDES) $< \
	| sed 's/\($*\)\.o[ :]*/\1.o \1_lo.o $@ : /g' > $@; \
		[ -s $@ ] || rm -f $@

DEPEND_FILES=$(subst .o,.d,$(LOCI_OBJS)) $(subst .o,.d,$(OBJS))
JUNK += $(subst .loci,.cc,$(LOCI_FILES))

#include automatically generated dependencies                                                                                                         
ifeq ($(filter $(MAKECMDGOALS),clean distclean),)
-include $(DEPEND_FILES)
endif
