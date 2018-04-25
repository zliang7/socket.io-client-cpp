LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := libsioclient

LOCAL_SRC_FILES := \
	src/sio_client.cpp \
	src/sio_socket.cpp \
	src/internal/sio_client_impl.cpp \
	src/internal/sio_packet.cpp \
	lib/boost/src/error_code.cpp

# Flags passed to both C and C++ files.
LOCAL_CPPFLAGS := -DBOOST_ASIO_DISABLE_BOOST_REGEX

LOCAL_CXXFLAGS := -std=c++11 -fvisibility=hidden

# Include paths placed before CFLAGS/CPPFLAGS
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/lib/websocketpp \
	$(LOCAL_PATH)/lib/rapidjson/include \
	$(LOCAL_PATH)/lib/boost/include

#ENABLE_TLS = 1
ifneq ($(ENABLE_TLS),)
LOCAL_CPPFLAGS += -DSIO_TLS
LOCAL_C_INCLUDES += $(openssl-includes)
LOCAL_REQUIRED_MODULES += openssl
LOCAL_SHARED_LIBRARIES += libcrypto libssl
endif

include $(BUILD_STATIC_LIBRARY)
#LOCAL_LDFLAGS += -lpthread
#include $(BUILD_SHARED_LIBRARY)
