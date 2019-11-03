# We try every input file whose name matches *.in.
# We parse it using each of the parsers,
# and compare the results pairwise.

MAIN="calc"
TARGETS="ocamlyacc menhir_code menhir_code_inline menhir_table menhir_table_inline"

# Create the output files.
for f in *.in ; do
    base=${f%*.in}
    out=$base.out
    echo "Processing $f..."
    for target in $TARGETS ; do
	$target/$MAIN.exe < $f > $target/$out
    done
done

# Compare the output files. Lots of comparisons.
for pair in \
    ocamlyacc/menhir_code \
        ocamlyacc/menhir_table \
        menhir_code/menhir_table \
        menhir_code_inline/menhir_table_inline \
        menhir_table/menhir_table_inline \
        menhir_code/menhir_code_inline
do
    left=${pair%/*}
    right=${pair#*/}
    for f in *.in ; do
	base=${f%*.in}
	out=$base.out
	log=$base.$left.$right.log
	if diff $left/$out $right/$out > $log ; then
	    echo "$left versus $right: $f: OK"
	else
	    echo "$left versus $right: $f: FAILURE"
	    cat $log
	fi
    done
done
