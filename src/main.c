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


    if(isCallableObject(m, "bar")) {
        callMethodArgs(m, "bar", Py_BuildValue("()"));
    }
    if(isCallableObject(m, "spam")) {
        callMethodArgs(m, "spam", argu);
        Py_DECREF(argu);
    }

    argu = Py_BuildValue("(i)", 42);
    PyObject *cl;
    if (isCallableObject(m, "A")) {
        argu = Py_BuildValue("(i)", 42);
        cl = newCls(m, "A", argu);
        printf("calling methods\n");

        callClsMethod(cl, "setA", Py_BuildValue("(i)", 10));

        callClsMethod(cl, "printA", Py_BuildValue("()"));

        Py_DECREF(argu);
        Py_DECREF(cl);
    }

    if (isCallableObject(m, "B")) {
        cl = newCls(m, "B", Py_BuildValue("()"));
        Py_DECREF(cl);
    }

    Py_DECREF(m);

    Py_Finalize();
    return 0;
}
