d=`readlink -f $0`
d=`dirname "${d}"`
d=$d/week1/students
cd "${d}"
./musical_pairs.sh