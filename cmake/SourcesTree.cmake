set(SRC_DIR
	${CMAKE_SOURCE_DIR}/py_stochastic_simulations/src
)

set(INCLUDE_DIR
	${CMAKE_SOURCE_DIR}/py_stochastic_simulations/include
)

set(HEADERS_EXTENSION ".h" ".hpp") 
set(SOURCES_EXTENSION ".c" ".cpp") 

file(GLOB HEADERS_CPU "${INCLUDE_DIR}/*.h" "${INCLUDE_DIR}/*.hpp")
file(GLOB SOURCES_CPU "${SRC_DIR}/*.c" "${SRC_DIR}/*.cpp")

set(HEADERS ${HEADERS_CPU})
set(SOURCES ${SOURCES_CPU})

if (USE_GPU)
  list(APPEND HEADERS_EXTENSION ".cuh")
  list(APPEND SOURCES_EXTENSION ".cu")

  file(GLOB HEADERS_GPU "${INCLUDE_DIR}/*.cuh")
  file(GLOB SOURCES_GPU "${SRC_DIR}/*.cu")

  list(APPEND HEADERS ${HEADERS_GPU})
  list(APPEND SOURCES ${SOURCES_GPU})
endif()


# Create file structure
if (WIN32)
  set(HEADERS_ROOT_LITERAL "Header Files")
  set(SOURCES_ROOT_LITERAL "Source Files")
  
  # Deterministic algorithms files pattern
  set(KRIGING_FILTER_PATTERNS ".*kriging.*")
  # Stohastic algorithms files pattern
  set(SGS_FILTER_PATTERNS ".*(sgs|simulation|spectral).*")
  # Smoothing algorithms files pattern
  set(SMOOTHING_FILTER_PATTERNS ".*smoothing.*")
  
  set(FILTERS "Deterministic" "Stohastic" "Smoothing")
  set(PATTERNS "${KRIGING_FILTER_PATTERNS}" "${SGS_FILTER_PATTERNS}" "${SMOOTHING_FILTER_PATTERNS}")

  set(ALL_FILES "${HEADERS}" "${SOURCES}")

  foreach(F ${ALL_FILES})
    get_filename_component(FNAME ${F} NAME)
	list(LENGTH FILTERS N)
	math(EXPR N ${N}-1)
    foreach(index RANGE 0 ${N} 1)
	    list(GET FILTERS ${index} FILTER_NAME)
	    list(GET PATTERNS ${index} PATTERN)
	    foreach(EXTENTION ${HEADERS_EXTENSION})
		  if(${FNAME} MATCHES "${PATTERN}\\${EXTENTION}")
		    source_group("${HEADERS_ROOT_LITERAL}\\${FILTER_NAME}" FILES ${F})
		  endif()
		endforeach()
	    foreach(EXTENTION ${SOURCES_EXTENSION})
		  if(${FNAME} MATCHES "${PATTERN}\\${EXTENTION}")
		    source_group("${SOURCES_ROOT_LITERAL}\\${FILTER_NAME}" FILES ${F})
		  endif()
		endforeach()
    endforeach()
  endforeach()

  source_group("${HEADERS_ROOT_LITERAL}\\Utils" FILES ${HEADERS})
  source_group("${SOURCES_ROOT_LITERAL}\\Utils" FILES ${SOURCES})

endif()