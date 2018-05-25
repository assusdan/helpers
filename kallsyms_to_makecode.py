import re
import os
import sys

# thanks to Maciej Klimas

def usage():
    print("%s <path to kallsyms>" % sys.argv[0] )
    print("%s /proc/kallsyms" % sys.argv[0] )


def main():
    prefix = """
#define UNLOADED_FILE   1
#include <idc.idc>

static main(void)
{
    """

    suffix = '}'
    format = '\tMakeCode\t (0x%s);'

    regex = re.compile( r'([a-fA-Z0-9]+) \w (\w+)' )


    #if( len(sys.argv) != 2 ):
    #    return usage()

    kallsymsPath = "kallsyms.txt"

    f = open( kallsymsPath, "r" )
    if None == f:
        print("Unable to open %s.\n", kallsymsPath )
        return -3
    f1 = open( "code.idc", "w")


    f1.write( "// Enabling addresses...")
    #cmd = 'echo 1 > /proc/sys/kernel/kptr_restrict'
    #os.system( cmd )
    
    f1.write(prefix)
    lines = f.readlines()
    for line in lines:
        match = regex.match(line)
        if( match != None ):
            f1.write( format % (match.group(1)) )

    f.close()

    f1.write(suffix)
    f1.close()

    return 0
    
    
if __name__ == '__main__':
    main()
 