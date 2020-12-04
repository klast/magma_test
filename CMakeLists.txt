# used features:
#   FindPython3 (3.12+)
#   MSVC_RUNTIME_LIBRARY (3.15+)
#   FindOpenMP (3.12+)
cmake_minimum_required(VERSION 3.15)

# tldr; this is required when setting MSVC_RUNTIME_LIBRARY (/MT, /MD, ...) property
# see also: https://cmake.org/cmake/help/latest/policy/CMP0091.html#policy:CMP0091
cmake_policy(SET CMP0091 NEW)


project(magma_test LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/)

  # detect CUDA
set( GPU_TARGET "Kepler Maxwell Pascal" CACHE STRING "CUDA architectures to compile for; one or more of Fermi, Kepler, Maxwell, Pascal, Volta, Turing, Ampere, or valid sm_[0-9][0-9]" )
find_package( CUDA )
if (CUDA_FOUND)
    message( STATUS "Found CUDA ${CUDA_VERSION}" )
    message( STATUS "    CUDA_INCLUDE_DIRS:   ${CUDA_INCLUDE_DIRS}"   )
    message( STATUS "    CUDA_CUDART_LIBRARY: ${CUDA_CUDART_LIBRARY}" )
    message( STATUS "    CUDA_LIBRARIES: ${CUDA_LIBRARIES}" )
    message( STATUS "    CUDA_CUBLAS_LIBRARIES: ${CUDA_CUBLAS_LIBRARIES}" )
    include_directories( ${CUDA_INCLUDE_DIRS} )

    # NVCC options for the different cards
    # sm_xx is binary, compute_xx is PTX for forward compatability
    # MIN_ARCH is lowest requested version
    # NV_SM    accumulates sm_xx for all requested versions
    # NV_COMP  is compute_xx for highest requested version
    set( NV_SM    "" )
    set( NV_COMP  "" )

    set(CUDA_SEPARABLE_COMPILATION OFF)

    # nvcc >= 6.5 supports -std=c++11, so propagate CXXFLAGS to NVCCFLAGS.
    # Older nvcc didn't support -std=c++11, so previously we disabled propagation.
    ##if (${CMAKE_CXX_FLAGS} MATCHES -std=)
    ##    set( CUDA_PROPAGATE_HOST_FLAGS OFF )
    ##endif()

    if (GPU_TARGET MATCHES Fermi)
        set( GPU_TARGET "${GPU_TARGET} sm_20" )
    endif()

    if (GPU_TARGET MATCHES Kepler)
        set( GPU_TARGET "${GPU_TARGET} sm_30 sm_35" )
    endif()

    if (GPU_TARGET MATCHES Maxwell)
        set( GPU_TARGET "${GPU_TARGET} sm_50" )
    endif()

    if (GPU_TARGET MATCHES Pascal)
        set( GPU_TARGET "${GPU_TARGET} sm_60" )
    endif()

    if (GPU_TARGET MATCHES Volta)
        set( GPU_TARGET "${GPU_TARGET} sm_70" )
    endif()

    if (GPU_TARGET MATCHES Turing)
        set( GPU_TARGET "${GPU_TARGET} sm_75" )
    endif()

    if (GPU_TARGET MATCHES Ampere)
        set( GPU_TARGET "${GPU_TARGET} sm_80" )
    endif()

    if (GPU_TARGET MATCHES sm_20)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 200 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_20,code=sm_20 )
        set( NV_COMP        -gencode arch=compute_20,code=compute_20 )
        message( STATUS "    compile for CUDA arch 2.0 (Fermi)" )
    endif()

    if (GPU_TARGET MATCHES sm_30)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 300 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_30,code=sm_30 )
        set( NV_COMP        -gencode arch=compute_30,code=compute_30 )
        message( STATUS "    compile for CUDA arch 3.0 (Kepler)" )
    endif()

    if (GPU_TARGET MATCHES sm_35)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 300 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_35,code=sm_35 )
        set( NV_COMP        -gencode arch=compute_35,code=compute_35 )
        message( STATUS "    compile for CUDA arch 3.5 (Kepler)" )
    endif()

    if (GPU_TARGET MATCHES sm_50)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 500 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_50,code=sm_50 )
        set( NV_COMP        -gencode arch=compute_50,code=compute_50 )
        message( STATUS "    compile for CUDA arch 5.0 (Maxwell)" )
    endif()

    if (GPU_TARGET MATCHES sm_52)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 520 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_52,code=sm_52 )
        set( NV_COMP        -gencode arch=compute_52,code=compute_52 )
        message( STATUS "    compile for CUDA arch 5.2 (Maxwell)" )
    endif()

    if (GPU_TARGET MATCHES sm_53)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 530 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_53,code=sm_53 )
        set( NV_COMP        -gencode arch=compute_53,code=compute_53 )
        message( STATUS "    compile for CUDA arch 5.3 (Maxwell)" )
    endif()

    if (GPU_TARGET MATCHES sm_60)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 600 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_60,code=sm_60 )
        set( NV_COMP        -gencode arch=compute_60,code=compute_60 )
        message( STATUS "    compile for CUDA arch 6.0 (Pascal)" )
    endif()

    if (GPU_TARGET MATCHES sm_61)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 610 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_61,code=sm_61 )
        set( NV_COMP        -gencode arch=compute_61,code=compute_61 )
        message( STATUS "    compile for CUDA arch 6.1 (Pascal)" )
    endif()

    if (GPU_TARGET MATCHES sm_62)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 620 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_62,code=sm_62 )
        set( NV_COMP        -gencode arch=compute_62,code=compute_62 )
        message( STATUS "    compile for CUDA arch 6.2 (Pascal)" )
    endif()

    if (GPU_TARGET MATCHES sm_70)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 700 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_70,code=sm_70 )
        set( NV_COMP        -gencode arch=compute_70,code=compute_70 )
        message( STATUS "    compile for CUDA arch 7.0 (Volta)" )
    endif()

    if (GPU_TARGET MATCHES sm_71)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 710 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_71,code=sm_71 )
        set( NV_COMP        -gencode arch=compute_71,code=compute_71 )
        message( STATUS "    compile for CUDA arch 7.1 (Volta)" )
    endif()

    if (GPU_TARGET MATCHES sm_75)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 750 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_75,code=sm_75 )
        set( NV_COMP        -gencode arch=compute_75,code=compute_75 )
        message( STATUS "    compile for CUDA arch 7.5 (Turing)" )
    endif()

    if (GPU_TARGET MATCHES sm_80)
        if (NOT MIN_ARCH)
            set( MIN_ARCH 800 )
        endif()
        set( NV_SM ${NV_SM} -gencode arch=compute_80,code=sm_80 )
        set( NV_COMP        -gencode arch=compute_80,code=compute_80 )
        message( STATUS "    compile for CUDA arch 8.0 (Ampere)" )
    endif()

    if ( ${GPU_TARGET} MATCHES "All")
      set( MIN_ARCH 370)
      SET( NV_SM ${CUDA_ARCH_LIST})
      SET( NV_COMP "")
    endif()

    if (NOT MIN_ARCH)
        message( FATAL_ERROR "GPU_TARGET must contain one or more of Fermi, Kepler, Maxwell, Pascal, Volta, Turing, Ampere, or valid sm_[0-9][0-9]" )
    endif()

    set( CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -DHAVE_CUBLAS -Xfatbin -compress-all -Xcompiler -fPIC -std=c++11 ${NV_SM} ${NV_COMP} ${FORTRAN_CONVENTION} )
    MESSAGE(STATUS "CUDA_NVCC_FLAGS: ${CUDA_NVCC_FLAGS}")
    add_definitions( "-DHAVE_CUBLAS -DMIN_CUDA_ARCH=${MIN_ARCH}" )
    message( STATUS "Define -DHAVE_CUBLAS -DMIN_CUDA_ARCH=${MIN_ARCH}" )
endif()
set(CMAKE_CUDA_STANDARD 14)
set(CMAKE_CUDA_STANDARD_REQUIRED TRUE)

add_executable(magma_test main.cpp)


### properties

set_target_properties(magma_test
	PROPERTIES
	CXX_STANDARD 17
	CXX_STANDARD_REQUIRED ON
)

   # use /MT[d] instead of /MD[d]
   add_definitions(-D_USE_MATH_DEFINES)
   #set_target_properties(magma_test PROPERTIES CUDA_SEPARABLE_COMPILATION ON)

### dependencies

# OpenMP
find_package(OpenMP REQUIRED)
target_link_libraries(magma_test PRIVATE ${OpenMP_CXX_LIBRARIES})
# skip SOURCES_CUDA because nvcc does not recognize -openmp flag
set_property(SOURCE ${SOURCES_CPU} ${PY_MAP_BUILDER_MAIN} ${MAP_BUILDER_MAIN}
              PROPERTY COMPILE_FLAGS ${OpenMP_CXX_FLAGS})
			  
       # MKL
    option(MKL_USE_parallel "Use MKL parallel" OFF)
    option(MKL_USE_sdl "Single Dynamic Library or static/dynamic" OFF)
    option(BLA_STATIC "Static mkl linking" ON)

    find_package(MKL REQUIRED)

    target_compile_definitions(magma_test PRIVATE USE_MKL)
    target_link_directories(magma_test PRIVATE ${MKL_LIBRARY_DIR})
    target_link_libraries(magma_test PRIVATE ${MKL_LIBRARIES})
    target_include_directories(magma_test PRIVATE ${MKL_INCLUDE_DIR})

# MAGMA
   target_compile_definitions(magma_test PRIVATE ADD_)
   target_compile_definitions(magma_test PRIVATE MAGMA_NOAFFINITY)
   include_directories($ENV{MAGMA_ROOT}/include)
   target_link_directories(magma_test PRIVATE $ENV{MAGMA_ROOT}/lib)
   target_link_libraries(magma_test PRIVATE magma)
   target_link_libraries(magma_test PRIVATE cublas cusparse cusolver cudadevrt.lib cudart_static.lib)