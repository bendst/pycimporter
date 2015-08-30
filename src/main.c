#include <Python.h>
#include "pycimport.h"

int main(int argc, char const *argv[]) {

    Py_Initialize();
    PyInit_pycimport();
    setEnv("plugins");
    PyRun_SimpleString("import sys; print(sys.path)");
    Py_Finalize();
    return 0;
}
