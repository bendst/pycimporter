#include "Python.h"
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

    m = loadModule("foo");
    argu = Py_BuildValue("(is)", a, b);

    if(isCallableObject(m, "bar")){
        callObject(m, "bar");
    }
    if(isCallableObject(m, "spam")){
        callObjectArgs(m, "spam", argu);
        Py_DECREF(argu);
    }

    argu = Py_BuildValue("(i)", 42);
    PyObject *cl;
    if (isCallableObject(m, "A")){
        argu = Py_BuildValue("(i)", 42);
        cl = newClass(m, "A", argu);
        printf("calling methods\n");

        callObjMethod(cl, "setA", Py_BuildValue("(i)", 10));

        callObjMethod(cl, "printA", Py_BuildValue("()"));
        /*
        if(isCallableObject(cl, "printA")){
            callObject(cl, "printA");
        }
        */
        Py_DECREF(argu);
        Py_DECREF(cl);
    }

    if (isCallableObject(m, "B")){
        cl = callObject(m, "B");
        Py_DECREF(cl);
    }

    Py_DECREF(m);

    Py_Finalize();
    return 0;
}
