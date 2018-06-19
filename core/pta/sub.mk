cppflags-$(CFG_ASN1_PARSER) += -DARGTYPE=4  # Make LTC_ARGCHK() return on error
cppflags-$(CFG_ASN1_PARSER) += -DLTC_CLEAN_STACK -DLTC_NO_TEST -DLTC_NO_PROTOTYPES
cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_TABLES -DLTC_HASH_HELPERS
cppflags-$(_CFG_CORE_LTC_SIZE_OPTIMIZATION) += -DLTC_SMALL_CODE

# https://github.com/OP-TEE/optee_os/issues/3290
cppflags-$(CFG_ASN1_PARSER) += -DLTC_SOURCE
#cppflags-$(CFG_ASN1_PARSER) += -DLTC_VERBOSE

cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_CIPHERS

ifneq (,$(filter y,$(_CFG_CORE_LTC_AES) $(_CFG_CORE_LTC_AES_DESC)))
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_RIJNDAEL
endif
ifeq ($(_CFG_CORE_LTC_DES),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_DES
endif

cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_MODES

ifeq ($(_CFG_CORE_LTC_ECB),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_ECB_MODE
endif
ifeq ($(_CFG_CORE_LTC_CBC),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_CBC_MODE
endif
ifeq ($(_CFG_CORE_LTC_CTR),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_CTR_MODE
endif
ifeq ($(_CFG_CORE_LTC_XTS),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_XTS_MODE
endif

cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_HASHES

ifeq ($(_CFG_CORE_LTC_MD5),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_MD5
endif
ifeq ($(_CFG_CORE_LTC_SHA1),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA1
endif
ifeq ($(_CFG_CORE_LTC_SHA1_ARM32_CE),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA1_ARM32_CE
endif
ifeq ($(_CFG_CORE_LTC_SHA1_ARM64_CE),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA1_ARM64_CE
endif
ifeq ($(_CFG_CORE_LTC_SHA224),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA224
endif
ifneq (,$(filter y,$(_CFG_CORE_LTC_SHA256) $(_CFG_CORE_LTC_SHA256_DESC)))
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA256
endif
ifeq ($(_CFG_CORE_LTC_SHA256_ARM32_CE),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA256_ARM32_CE
endif
ifeq ($(_CFG_CORE_LTC_SHA256_ARM64_CE),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA256_ARM64_CE
endif
ifneq (,$(filter y,$(_CFG_CORE_LTC_SHA384) $(_CFG_CORE_LTC_SHA384_DESC)))
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA384
endif
ifneq (,$(filter y,$(_CFG_CORE_LTC_SHA512) $(_CFG_CORE_LTC_SHA512_DESC)))
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA512
endif
ifeq ($(_CFG_CORE_LTC_SHA512_256),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_SHA512_256
endif

cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_MACS

ifeq ($(_CFG_CORE_LTC_HMAC),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_HMAC
endif
ifeq ($(_CFG_CORE_LTC_CMAC),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_OMAC
endif
ifeq ($(_CFG_CORE_LTC_CCM),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_CCM_MODE
endif
ifeq ($(_CFG_CORE_LTC_GCM),y)
	cppflags-$(CFG_ASN1_PARSER) += -DLTC_GCM_MODE
endif

cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_PK

ifeq ($(_CFG_CORE_LTC_RSA),y)
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_MRSA
endif
ifeq ($(_CFG_CORE_LTC_DSA),y)
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_MDSA
endif
ifeq ($(_CFG_CORE_LTC_DH),y)
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_MDH
endif
ifeq ($(_CFG_CORE_LTC_ECC),y)
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_MECC

   # use Shamir's trick for point mul (speeds up signature verification)
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_ECC_SHAMIR

   cppflags-$(CFG_ASN1_PARSER) += -DLTC_ECC192
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_ECC224
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_ECC256
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_ECC384
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_ECC521

   # ECC 521 bits is the max supported key size
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_MAX_ECC=521
endif

cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_PKCS

ifneq (,$(filter y,$(_CFG_CORE_LTC_RSA) $(_CFG_CORE_LTC_DSA) $(_CFG_CORE_LTC_ECC) $(_CFG_CORE_LTC_HASH)))
   cppflags-$(CFG_ASN1_PARSER) += -DLTC_DER
endif

cppflags-$(CFG_ASN1_PARSER) += -DLTC_NO_PRNGS -DLTC_FORTUNA

cppflags-$(CFG_ASN1_PARSER) += -Ilib/libmpa

######

subdirs-$(CFG_TEE_CORE_EMBED_INTERNAL_TESTS) += tests

srcs-$(CFG_TEE_BENCHMARK) += benchmark.c
srcs-$(CFG_DEVICE_ENUM_PTA) += device.c
srcs-$(CFG_TA_GPROF_SUPPORT) += gprof.c
srcs-$(CFG_SDP_PTA) += sdp.c
ifeq ($(CFG_WITH_USER_TA),y)
srcs-$(CFG_SECSTOR_TA_MGMT_PTA) += secstor_ta_mgmt.c
endif
srcs-$(CFG_WITH_STATS) += stats.c
srcs-$(CFG_SYSTEM_PTA) += system.c

subdirs-y += bcm

srcs-$(CFG_ASN1_PARSER) += asn1_parser.c
srcs-$(CFG_ASN1_PARSER) += attestations.c
srcs-$(CFG_ASN1_PARSER) += encoders.c
