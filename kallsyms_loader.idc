/* kallsyms loader */
/* by goroh_kun    */
/* modified from H2enum Version 1.09 */

#include <idc.idc>

// returns -1 if symbol is NOT 'space'
static is_space(c)
{
	return strstr(" \t\r\n\b",c);
}

// strip leading blank characters from string.
static ltrim(str)
{
	auto pos,c,l;

	l = strlen(str);
	pos = 0;
	while (pos < l)
	{
		c = substr(str,pos,pos+1);
		if (is_space(c) == -1) break;
		pos++;
	}
	return substr(str,pos,-1);
}

// strip trailing blank characters from string.
static rtrim(str)
{
	auto pos,c;

	pos = strlen(str);
	while (pos > 0)
	{
		c = substr(str,pos-1,pos);
		if (is_space(c) == -1) break;
		pos--;
	}
	return substr(str,0,pos);
}

// Find first delimiter position in string (SPACE or TAB).
static FindDelim(str)
{
	auto pos1,pos2;

	pos1 = strstr(str," ");
	pos2 = strstr(str,"\t");
	if (pos1 == -1)  return pos2;
	if (pos2 == -1)  return pos1;
	if (pos1 < pos2) return pos1;
	else		 return pos2;
}

// Main conversion routine
static load_kallsyms(fname)
{
        auto def_addr, def_name, def_type;
	auto hFile,in_str,pos,str_no,c;

        if ((hFile=fopen(fname,"r")) == 0)
	{
		Warning("Couldn't open file '%s'!",fname);
		return -1;
	}

	Message("Conversion started...\n");

	str_no = 0;
	while ((in_str=readstr(hFile)) != -1)
	{
		str_no++;
		pos = FindDelim(in_str);
		def_addr = xtol(substr(in_str, 0, pos));
		in_str = substr(in_str, pos + 1, -1);
		pos = FindDelim(in_str);
		def_type = substr(in_str, 0, pos);
		in_str = substr(in_str, pos + 1, -1);
		def_name = trim(in_str);
		if (def_type == 'T' || def_type == 't') MakeCode(def_addr);
		if(0 == MakeNameEx(def_addr, def_name, SN_NOCHECK | SN_NOWARN | SN_AUTO)){
			auto i;
			for(i=1; i<100; i++){
				def_name = def_name + "_" + ltoa(i, 10);
				if(0 != MakeNameEx(def_addr, def_name, SN_NOCHECK | SN_NOWARN | SN_AUTO)){
					break;
				}
			}
		}
		Message("name %s = '%08x'(%s)\n", def_name, def_addr, def_type);
	}
	fclose(hFile);

	Message("Successful %d elements imported.\n", str_no);
	return 0;
}

static main()
{
	auto fname;

	fname = AskFile(0,"*.txt","Choose a kallsyms file to parse:");
	if (fname == "") return;
	load_kallsyms(fname);
}