
TARGETS_L431 := \
    VIMDRONES_L431 

HAL_FOLDER_L431 := $(HAL_FOLDER)/l431

MCU_L431 := -mcpu=cortex-m4 -mthumb -g -gdwarf-2
# LDSCRIPT_L431 := $(HAL_FOLDER_L431)/STM32L431KBUX_FLASH.ld
LDSCRIPT_L431 := $(HAL_FOLDER_L431)/STM32L431KCUX_FLASH.ld

SRC_DIR_L431 := \
	$(HAL_FOLDER_L431)/Startup \
	$(HAL_FOLDER_L431)/Src \
	$(HAL_FOLDER_L431)/Drivers/STM32L4xx_HAL_Driver/Src \
	modules/DroneCAN/libcanard \
	modules/DroneCAN/libcanard/drivers/stm32 \
	Src/DroneCAN

CFLAGS_L431 := \
	-I$(HAL_FOLDER_L431)/Inc \
	-I$(HAL_FOLDER_L431)/Drivers/STM32L4xx_HAL_Driver/Inc \
	-I$(HAL_FOLDER_L431)/Drivers/CMSIS/Include \
	-I$(HAL_FOLDER_L431)/Drivers/CMSIS/Device/ST/STM32L4xx/Include \
	-Imodules/DroneCAN/libcanard \
	-Imodules/DroneCAN/libcanard/drivers/stm32 \
	-Igen/dsdl_generated/include \
	-ISrc/DroneCAN

CFLAGS_L431 += \
	-DHSE_VALUE=8000000 \
	-DSTM32L431xx \
	-DHSE_STARTUP_TIMEOUT=100 \
	-DLSE_STARTUP_TIMEOUT=5000 \
	-DLSE_VALUE=32768 \
	-DDATA_CACHE_ENABLE=1 \
	-DINSTRUCTION_CACHE_ENABLE=0 \
	-DVDD_VALUE=3300 \
	-DLSI_VALUE=32000 \
	-DHSI_VALUE=16000000 \
	-DUSE_FULL_LL_DRIVER \
	-DPREFETCH_ENABLE=1 \
	-DDRONECAN_SUPPORT=1

SRC_L431 := $(foreach dir,$(SRC_DIR_L431),$(wildcard $(dir)/*.[cs]))

# add in generated code
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.NodeStatus.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.GetNodeInfo_res.c
SRC_L431 += gen/dsdl_generated/src/uavcan.equipment.esc.RawCommand.c
SRC_L431 += gen/dsdl_generated/src/uavcan.equipment.esc.Status.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.dynamic_node_id.Allocation.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.param.GetSet_req.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.param.GetSet_res.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.param.ExecuteOpcode_req.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.param.ExecuteOpcode_res.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.file.BeginFirmwareUpdate_req.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.file.BeginFirmwareUpdate_res.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.file.Read_req.c
SRC_L431 += gen/dsdl_generated/src/uavcan.protocol.file.Read_res.c

dsdl_generate:
	$(QUIET)mkdir -p gen/dsdl_generated
	$(QUIET)python3 modules/DroneCAN/dronecan_dsdlc/dronecan_dsdlc.py -O gen/dsdl_generated modules/DroneCAN/DSDL/dronecan modules/DroneCAN/DSDL/uavcan modules/DroneCAN/DSDL/com modules/DroneCAN/DSDL/ardupilot
