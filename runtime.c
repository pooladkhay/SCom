#include <stdio.h>

extern int scheme_entry();

int main(int argc, char const *argv[])
{
    printf("%d\n", scheme_entry());
    return 0;
}
