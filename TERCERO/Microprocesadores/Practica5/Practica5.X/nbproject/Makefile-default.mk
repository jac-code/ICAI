#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=seccion2_main.c ../Practica3/Practica_3.X/Pic32Ini.c seccion3_main.c TemporizadorTimer3.c TemporizadorTimer2.c Temporizador.c seccion4_main.c TemporizadorSeccion4.c seccion2_main_simple.c seccion2_1_main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/seccion2_main.o ${OBJECTDIR}/_ext/498231017/Pic32Ini.o ${OBJECTDIR}/seccion3_main.o ${OBJECTDIR}/TemporizadorTimer3.o ${OBJECTDIR}/TemporizadorTimer2.o ${OBJECTDIR}/Temporizador.o ${OBJECTDIR}/seccion4_main.o ${OBJECTDIR}/TemporizadorSeccion4.o ${OBJECTDIR}/seccion2_main_simple.o ${OBJECTDIR}/seccion2_1_main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/seccion2_main.o.d ${OBJECTDIR}/_ext/498231017/Pic32Ini.o.d ${OBJECTDIR}/seccion3_main.o.d ${OBJECTDIR}/TemporizadorTimer3.o.d ${OBJECTDIR}/TemporizadorTimer2.o.d ${OBJECTDIR}/Temporizador.o.d ${OBJECTDIR}/seccion4_main.o.d ${OBJECTDIR}/TemporizadorSeccion4.o.d ${OBJECTDIR}/seccion2_main_simple.o.d ${OBJECTDIR}/seccion2_1_main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/seccion2_main.o ${OBJECTDIR}/_ext/498231017/Pic32Ini.o ${OBJECTDIR}/seccion3_main.o ${OBJECTDIR}/TemporizadorTimer3.o ${OBJECTDIR}/TemporizadorTimer2.o ${OBJECTDIR}/Temporizador.o ${OBJECTDIR}/seccion4_main.o ${OBJECTDIR}/TemporizadorSeccion4.o ${OBJECTDIR}/seccion2_main_simple.o ${OBJECTDIR}/seccion2_1_main.o

# Source Files
SOURCEFILES=seccion2_main.c ../Practica3/Practica_3.X/Pic32Ini.c seccion3_main.c TemporizadorTimer3.c TemporizadorTimer2.c Temporizador.c seccion4_main.c TemporizadorSeccion4.c seccion2_main_simple.c seccion2_1_main.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=32MX230F064D
MP_LINKER_FILE_OPTION=
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/seccion2_main.o: seccion2_main.c  .generated_files/d955ef8cbd9adc9924c30cedd39234b9a19afec4.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion2_main.o.d 
	@${RM} ${OBJECTDIR}/seccion2_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion2_main.o.d" -o ${OBJECTDIR}/seccion2_main.o seccion2_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/_ext/498231017/Pic32Ini.o: ../Practica3/Practica_3.X/Pic32Ini.c  .generated_files/9e097b1cac8573fefc1cb65a8dcac6b0c16c75d4.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}/_ext/498231017" 
	@${RM} ${OBJECTDIR}/_ext/498231017/Pic32Ini.o.d 
	@${RM} ${OBJECTDIR}/_ext/498231017/Pic32Ini.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/498231017/Pic32Ini.o.d" -o ${OBJECTDIR}/_ext/498231017/Pic32Ini.o ../Practica3/Practica_3.X/Pic32Ini.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion3_main.o: seccion3_main.c  .generated_files/ec9b3e17b166a4780e63c66bb5f6231294b815fa.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion3_main.o.d 
	@${RM} ${OBJECTDIR}/seccion3_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion3_main.o.d" -o ${OBJECTDIR}/seccion3_main.o seccion3_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/TemporizadorTimer3.o: TemporizadorTimer3.c  .generated_files/7d39cc9fcca188c4b45dc2477e2b9f3759bbe664.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TemporizadorTimer3.o.d 
	@${RM} ${OBJECTDIR}/TemporizadorTimer3.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TemporizadorTimer3.o.d" -o ${OBJECTDIR}/TemporizadorTimer3.o TemporizadorTimer3.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/TemporizadorTimer2.o: TemporizadorTimer2.c  .generated_files/75a2b79441c5d25c78624a90188255d9aed27530.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TemporizadorTimer2.o.d 
	@${RM} ${OBJECTDIR}/TemporizadorTimer2.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TemporizadorTimer2.o.d" -o ${OBJECTDIR}/TemporizadorTimer2.o TemporizadorTimer2.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/Temporizador.o: Temporizador.c  .generated_files/f7185bf6e9e496f290ccf32bd9e2a1b30c2a9a84.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Temporizador.o.d 
	@${RM} ${OBJECTDIR}/Temporizador.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Temporizador.o.d" -o ${OBJECTDIR}/Temporizador.o Temporizador.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion4_main.o: seccion4_main.c  .generated_files/7a57dbf2b46e02dead91dc70fda81f31354e0c2a.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion4_main.o.d 
	@${RM} ${OBJECTDIR}/seccion4_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion4_main.o.d" -o ${OBJECTDIR}/seccion4_main.o seccion4_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/TemporizadorSeccion4.o: TemporizadorSeccion4.c  .generated_files/26f0635daa8a7268f4d3defdeef49922adf18131.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TemporizadorSeccion4.o.d 
	@${RM} ${OBJECTDIR}/TemporizadorSeccion4.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TemporizadorSeccion4.o.d" -o ${OBJECTDIR}/TemporizadorSeccion4.o TemporizadorSeccion4.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion2_main_simple.o: seccion2_main_simple.c  .generated_files/527d4f8095773eb9812f5210141766e26de38291.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion2_main_simple.o.d 
	@${RM} ${OBJECTDIR}/seccion2_main_simple.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion2_main_simple.o.d" -o ${OBJECTDIR}/seccion2_main_simple.o seccion2_main_simple.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion2_1_main.o: seccion2_1_main.c  .generated_files/e59e2f7df77642d5fab58c894ebafceb0c6eab48.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion2_1_main.o.d 
	@${RM} ${OBJECTDIR}/seccion2_1_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE) -g -D__DEBUG   -fframe-base-loclist  -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion2_1_main.o.d" -o ${OBJECTDIR}/seccion2_1_main.o seccion2_1_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
else
${OBJECTDIR}/seccion2_main.o: seccion2_main.c  .generated_files/e5cc32c4ed4533da613e4b18b710bb56a0fbc1c0.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion2_main.o.d 
	@${RM} ${OBJECTDIR}/seccion2_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion2_main.o.d" -o ${OBJECTDIR}/seccion2_main.o seccion2_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/_ext/498231017/Pic32Ini.o: ../Practica3/Practica_3.X/Pic32Ini.c  .generated_files/b6df89f705285fb631712f4df0fa5a6c3735c54c.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}/_ext/498231017" 
	@${RM} ${OBJECTDIR}/_ext/498231017/Pic32Ini.o.d 
	@${RM} ${OBJECTDIR}/_ext/498231017/Pic32Ini.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/_ext/498231017/Pic32Ini.o.d" -o ${OBJECTDIR}/_ext/498231017/Pic32Ini.o ../Practica3/Practica_3.X/Pic32Ini.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion3_main.o: seccion3_main.c  .generated_files/27da49a81318bdf81f696e290a7e9663654b8b51.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion3_main.o.d 
	@${RM} ${OBJECTDIR}/seccion3_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion3_main.o.d" -o ${OBJECTDIR}/seccion3_main.o seccion3_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/TemporizadorTimer3.o: TemporizadorTimer3.c  .generated_files/eb78aff28a6bc0de2fc609f512dc7b773a7c2210.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TemporizadorTimer3.o.d 
	@${RM} ${OBJECTDIR}/TemporizadorTimer3.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TemporizadorTimer3.o.d" -o ${OBJECTDIR}/TemporizadorTimer3.o TemporizadorTimer3.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/TemporizadorTimer2.o: TemporizadorTimer2.c  .generated_files/b53b6b54e4e427ce4fb43829ed8c109b413d0296.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TemporizadorTimer2.o.d 
	@${RM} ${OBJECTDIR}/TemporizadorTimer2.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TemporizadorTimer2.o.d" -o ${OBJECTDIR}/TemporizadorTimer2.o TemporizadorTimer2.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/Temporizador.o: Temporizador.c  .generated_files/12bd1b65dd3f7a91b00d7591c87243a11f6b79c8.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/Temporizador.o.d 
	@${RM} ${OBJECTDIR}/Temporizador.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/Temporizador.o.d" -o ${OBJECTDIR}/Temporizador.o Temporizador.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion4_main.o: seccion4_main.c  .generated_files/302bcfd0b6985dfc46f197c45a4684d6f028d34c.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion4_main.o.d 
	@${RM} ${OBJECTDIR}/seccion4_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion4_main.o.d" -o ${OBJECTDIR}/seccion4_main.o seccion4_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/TemporizadorSeccion4.o: TemporizadorSeccion4.c  .generated_files/7dd6b63f3b0f5784650505fef5c51fc3ac27473e.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/TemporizadorSeccion4.o.d 
	@${RM} ${OBJECTDIR}/TemporizadorSeccion4.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/TemporizadorSeccion4.o.d" -o ${OBJECTDIR}/TemporizadorSeccion4.o TemporizadorSeccion4.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion2_main_simple.o: seccion2_main_simple.c  .generated_files/979b010e03ecbee566f78130e81f956f927268d0.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion2_main_simple.o.d 
	@${RM} ${OBJECTDIR}/seccion2_main_simple.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion2_main_simple.o.d" -o ${OBJECTDIR}/seccion2_main_simple.o seccion2_main_simple.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
${OBJECTDIR}/seccion2_1_main.o: seccion2_1_main.c  .generated_files/a0189f87cce05838db49ba3b1227ffa95219e1cf.flag .generated_files/9c38dd73fa47c8727ca672a3ac38932765b77050.flag
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/seccion2_1_main.o.d 
	@${RM} ${OBJECTDIR}/seccion2_1_main.o 
	${MP_CC}  $(MP_EXTRA_CC_PRE)  -g -x c -c -mprocessor=$(MP_PROCESSOR_OPTION)  -MP -MMD -MF "${OBJECTDIR}/seccion2_1_main.o.d" -o ${OBJECTDIR}/seccion2_1_main.o seccion2_1_main.c    -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -mdfp="${DFP_DIR}"  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: compileCPP
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -g   -mprocessor=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)      -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,-D=__DEBUG_D,--no-code-in-dinit,--no-dinit-in-serial-mem,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -mdfp="${DFP_DIR}"
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE)  -mprocessor=$(MP_PROCESSOR_OPTION)  -o dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}          -DXPRJ_default=$(CND_CONF)  -legacy-libc  $(COMPARISON_BUILD)  -Wl,--defsym=__MPLAB_BUILD=1$(MP_EXTRA_LD_POST)$(MP_LINKER_FILE_OPTION),--no-code-in-dinit,--no-dinit-in-serial-mem,-Map="${DISTDIR}/${PROJECTNAME}.${IMAGE_TYPE}.map",--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -mdfp="${DFP_DIR}"
	${MP_CC_DIR}\\xc32-bin2hex dist/${CND_CONF}/${IMAGE_TYPE}/Practica5.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX} 
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
