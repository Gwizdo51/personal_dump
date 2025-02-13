# comggen:
# "*"		-> visible files/dirs
# "*/"		-> visible dirs
# ".[!.]*"	-> hidden files/dirs
# ".[!.]*/"	-> hidden dirs

v1="./*"
v2="./*/"
v3="./.[!.]*"
v4="./.[!.]*/"

if compgen -G $v1 > /dev/null
then
	if compgen -G $v2 > /dev/null
	then
		if compgen -G $v3 > /dev/null
		then
			if compgen -G $v4 > /dev/null
			then
				du -sch $v2 $v4 $v1 $v3
			else
				du -sch $v2 $v1 $v3
			fi
		else
			du -sch $v2 $v1
		fi
	else
		if compgen -G $v3 > /dev/null
		then
			if compgen -G $v4 > /dev/null
			then
				du -sch $v4 $v1 $v3
			else
				du -sch $v1 $v3
			fi
		else
			du -sch $v1
		fi
	fi
else
	if compgen -G $v3 > /dev/null
	then
		if compgen -G $v4 > /dev/null
		then
			du -sch $v4 $v3
		else
			du -sch $v3
		fi
	else
		du -sch ./
	fi
fi
