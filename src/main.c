#include <Python.h>
#include "pycimport.h"

int main(int argc, char const *argv[]) {
    PyObject *m;
    Py_Initialize();
    PyInit_pycimport();
    setEnv("plugins");
    PyRun_SimpleString("import sys; print(sys.path)");

    m = loadModule("foo");

    if(callableMethod(m, "bar")){
        callMethod(m, "bar");
    }

    Py_Finalize();
    return 0;
}
