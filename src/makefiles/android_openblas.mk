# OpenBLAS specific Android configuration

ifndef DOUBLE_PRECISION
$(error DOUBLE_PRECISION not defined.)
endif
ifndef OPENFSTINC
$(error OPENFSTINC not defined.)
endif
ifndef OPENFSTLIBS
$(error OPENFSTLIBS not defined.)
endif
ifndef OPENBLASINC
$(error OPENBLASINC not defined.)
endif
ifndef OPENBLASLIBS
$(error OPENBLASLIBS not defined.)
endif
ifndef ANDROIDINC
$(error ANDROIDINC not defined.)
endif

COMPILER = $(shell $(CXX) -v 2>&1)
ifneq ($(findstring clang,$(COMPILER)),clang)
$(error Android build does not support compiling with $(CXX).
        Supported compilers: clang++)
endif

CXXFLAGS = -std=c++11 -I.. -I$(OPENFSTINC) $(EXTRA_CXXFLAGS) \
           -Wall -Wno-sign-compare -Wno-unused-local-typedefs \
           -Wno-deprecated-declarations -Winit-self -Wno-mismatched-tags \
           -DKALDI_DOUBLEPRECISION=$(DOUBLE_PRECISION) \
           -DHAVE_EXECINFO_H=1 -DHAVE_CXXABI_H -DHAVE_OPENBLAS -DANDROID_BUILD \
           -I$(OPENBLASINC) -I$(ANDROIDINC) -ftree-vectorize -mfloat-abi=hard \
           -mfpu=neon -mhard-float -D_NDK_MATH_NO_SOFTFP=1 -pthread \
           -g # -O0 -DKALDI_PARANOID

ifeq ($(KALDI_FLAVOR), dynamic)
CXXFLAGS += -fPIC
endif

LDFLAGS = $(EXTRA_LDFLAGS) $(OPENFSTLDFLAGS) -Wl,--no-warn-mismatch -pie
LDLIBS = $(EXTRA_LDLIBS) $(OPENFSTLIBS) $(OPENBLASLIBS) -lm_hard -ldl
