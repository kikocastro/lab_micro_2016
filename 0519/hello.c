#include <stdio.h>


int a_global = 10;

int foo ( int arg )
{
static int foo_counts = 0;

foo_counts++;
return foo_counts + arg;
}

int main ( void )
{
int nloops;
char* charstr = "hello, world!\n";

for( nloops = 0; nloops < 10; nloops++ ) {
printf( "%s", charstr );
foo( nloops );
}

return 0;
}
