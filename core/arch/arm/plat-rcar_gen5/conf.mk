PLATFORM_FLAVOR ?= X5H
include core/arch/arm/cpu/cortex-armv8-0.mk

$(call force,CFG_SECURE_TIME_SOURCE_CNTPCT,y)
$(call force,CFG_WITH_ARM_TRUSTED_FW,y)
$(call force,CFG_GIC,y)
$(call force,CFG_CORE_LARGE_PHYS_ADDR,y)
$(call force,CFG_CORE_ARM64_PA_BITS,36)
# Workaround (COMPILE_TIME_ASSERT was removed in recent optee_os versions):
# CFG_NS_VIRTUALIZATION requires each guest's base translation table to fit
# in one 4KB page (core_alloc_mmu_prtn(), core_mmu_lpae.c). Its size is
# NUM_BASE_TABLES * CFG_TEE_CORE_NB_CORE * NUM_BASE_LEVEL_ENTRIES * 8. With
# 32 cores and CFG_CORE_UNMAP_CORE_AT_EL0=y (2 tables), a 36-bit VA
# (level-1, 64 entries) yields 2*32*64*8 = 32KB and fails the
# COMPILE_TIME_ASSERT. A 33-bit VA stays level-1 with 8 entries -> 2*32*8*8
# = 4KB, fitting exactly. 8GB of VA is ample: all static maps are below 4GB
# and guest SHM is mapped on demand into the 32MB MEM_AREA_SHM_VASPACE
# window, so the high DRAM banks only need PA reach (CFG_AUTO_MAX_PA_BITS),
# not VA. Non-virtualization builds keep 36-bit VA.
ifeq ($(CFG_NS_VIRTUALIZATION),y)
$(call force,CFG_LPAE_ADDR_SPACE_BITS,33)
else
$(call force,CFG_LPAE_ADDR_SPACE_BITS,36)
endif
# Use the runtime HW PARange (ID_AA64MMFR0_EL1) instead of the hard-coded
# 36-bit (64GB) limit, so OP-TEE can address and map dynamic SHM in the
# DRAM banks above 64GB where Xen places guest RAM. Same approach as
# plat-vexpress (virtualization).
CFG_AUTO_MAX_PA_BITS ?= y
# Disable core ASLR for two reasons:
# 1. There is no source for ALSR seed, as Rcar platform
# does not provide DTB to OP-TEE. Also, there is no
# publically available documentation on integrated
# hardware RNG, so we can't use it either.
# 2. OP-TEE crashes during boot with enabled CFG_CORE_ASLR.
$(call force,CFG_CORE_ASLR,n)
$(call force,CFG_ARM64_core,y)
$(call force,CFG_WITH_LPAE,y)
ifeq ($(PLATFORM_FLAVOR), X5H)
$(call force,CFG_RCAR_GEN5, y)
endif

CFG_ARM_GICV3 ?= y
CFG_CRYPTO_WITH_CE ?= n
CFG_TZDRAM_START ?= 0x8C400000
CFG_TZDRAM_SIZE  ?= 0x02000000
CFG_TEE_RAM_VA_SIZE ?= 0x100000
supported-ta-targets = ta_arm64
CFG_DT ?= n
CFG_WITH_SOFTWARE_PRNG ?= y
CFG_TEE_CORE_DEBUG ?= n

ifeq ($(CFG_RCAR_GEN5), y)
# 1xx - for SCIFxx
# 2xx - for HSCIFxx
CFG_RCAR_UART ?= 200
$(call force,CFG_CORE_CLUSTER_SHIFT,2) #log2(2) = 4 --> 4(cores/per cluster)
$(call force,CFG_TEE_CORE_NB_CORE,32)
CFG_NUM_THREADS ?= $(CFG_TEE_CORE_NB_CORE)
CFG_MMAP_REGIONS ?= 21
endif

# For logging function
# Compiler switch - Debug log(Linux terminal log)
RCAR_DEBUG_LOG ?= 0
ifneq ($(RCAR_DEBUG_LOG),0)
core-platform-cflags += -DRCAR_DEBUG_LOG
endif

# For virtualization
ifeq ($(CFG_NS_VIRTUALIZATION),y)
CFG_VIRT_GUEST_COUNT ?= 3
CFG_RCAR_MUTEX_DELAY ?= 1
core-platform-cflags += -DCFG_RCAR_MUTEX_DELAY=$(CFG_RCAR_MUTEX_DELAY)
CFG_CORE_RESERVED_SHM ?= n
endif

# For Direct mapping function
core-platform-cflags += -DRCAR_MMU_DIRECT_MAPPING

# For using the rsipm functions
RCAR_TRNG_BY_RSIPM_HWENGINE ?= n
CFG_RSIPM_FW_SERVICE ?= n
ifeq ($(CFG_RSIPM_FW_SERVICE), y)
RCAR_TRNG_BY_RSIPM_HWENGINE = y
core-platform-cflags += -DRCAR_TRNG_BY_RSIPM_HWENGINE
endif

# For Dynamic TA Authentication
CFG_DYNAMIC_TA_AUTH_BY_HWENGINE ?= n
ifeq ($(CFG_DYNAMIC_TA_AUTH_BY_HWENGINE),y)
core-platform-cflags += -DRCAR_DYNAMIC_TA_AUTH_BY_HWENGINE
endif

# For MFIS mutex lock/unlock by HSCIF0
ifeq ($(CFG_SCIF),y)
CFG_MFIS_DRV = y
endif
