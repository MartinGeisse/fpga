ssh martin@ise ./auto-ise/clean.sh
scp -r src martin@ise:./auto-ise
ssh martin@ise ./auto-ise/build.sh $1
