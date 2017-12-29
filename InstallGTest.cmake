
# We must run the following at "include" time, not at function call time,
# to find the path to this module rather than the path to a calling list file
get_filename_component(_gitdescmoddir ${CMAKE_CURRENT_LIST_FILE} PATH)

function(install_gtest)
    # Download and unpack googletest at configure time
    configure_file("${_gitdescmoddir}/InstallGTestConfig.txt.in" "googletest-download/CMakeLists.txt")
    execute_process(COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" .
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/googletest-download" )
    execute_process(COMMAND "${CMAKE_COMMAND}" --build .
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/googletest-download" )

    # Prevent GoogleTest from overriding our compiler/linker options
    # when building with Visual Studio
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

    # Add googletest directly to our build. This adds
    # the following targets: gtest, gtest_main, gmock
    # and gmock_main
    add_subdirectory("${CMAKE_BINARY_DIR}/googletest-src"
                    "${CMAKE_BINARY_DIR}/googletest-build")

    # The gtest/gmock targets carry header search path
    # dependencies automatically when using CMake 2.8.11 or
    # later. Otherwise we have to add them here ourselves.
    if(CMAKE_VERSION VERSION_LESS 2.8.11)
        include_directories("${gtest_SOURCE_DIR}/include"
                            "${gmock_SOURCE_DIR}/include")
    endif()

    set(GTEST_INCLUDE_DIR "${gtest_INCLUDE_DIR}")
    set(GTEST_SOURCE_DIR "${gtest_SOURCE_DIR}")
    set(GMOCK_INCLUDE_DIR "${gmock_INCLUDE_DIR}")
    set(GMOCK_SOURCE_DIR "${gmock_SOURCE_DIR}")
endfunction()
