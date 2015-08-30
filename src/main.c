#include <Python.h>
#include "pycimport.h"
#include <string.h>

int main(int argc, char const *argv[]) {
    PyObject *m;
    PyObject *argu;


    int a = 42;
    char *b = "abc";

    Py_Initialize();
    PyInit_pycimport();

    setEnv("plugins");
    PyRun_SimpleString("import sys; print(sys.path)");

    m = loadModule("foo");
    argu = Py_BuildValue("(is)", a, b);
    
    if(callableMethod(m, "bar")){
        callMethod(m, "bar");
    }
    if(callableMethod(m, "spam")){
        callMethodArgs(m, "spam", argu);
    }

    Py_Finalize();
    return 0;
}
