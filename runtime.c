#include <stdio.h>

extern int scheme_entry();

/* define all scheme constants */
#define BOOL_F 0x2F
#define BOOL_T 0x6F
#define FX_MASK 0x03
#define FX_TAG 0x00
#define FX_SHIFT 2
#define EMPTY_LIST 0x3F
#define CHAR_MASK 0xFF
#define CHAR_TAG 0x0F
#define CHAR_SHIFT 8

/* all scheme values are of type ptrs */
typedef unsigned int ptr;

static void print_ptr(ptr x)
{
    if ((x & FX_MASK) == FX_TAG)
    {
        printf("%d\n", ((int)x) >> FX_SHIFT);
    }
    else if ((x & CHAR_MASK) == CHAR_TAG)
    {
        unsigned int ch = ((unsigned int)x) >> CHAR_SHIFT;
        switch (ch)
        {
        case 9:
            printf("#\\tab\n");
            break;
        case 10:
            printf("#\\newline\n");
            break;
        case 13:
            printf("#\\return\n");
            break;

        case 32:
            printf("#\\space\n");
            break;

        default:
            printf("#\\\%c\n", ch);
            break;
        }
    }
    else if (x == BOOL_T)
    {
        printf("#t\n");
    }
    else if (x == BOOL_F)
    {
        printf("#f\n");
    }
    else if (x == EMPTY_LIST)
    {
        printf("()\n");
    }
    else
    {
        printf("#<unknown 0x%08x>\n", x);
    }
}

int main(int argc, char const *argv[])
{
    print_ptr(scheme_entry());
    return 0;
}
