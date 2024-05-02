unix_millis="$(date +%s%3N)"
[ -d /tmp/sch_sh/ ] || mkdir /tmp/sch_sh
printf "\033[0;32mEnter your Prompt:\033[00m\n"
read -e searchquery1
#searchquery1="protein structure"
searchquery="$(echo $searchquery1 | sed 's/ /+/g'  )"
for i in {1..3}
do
curl -A 'Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0' "https://scholar.google.com/scholar?hl=en&start=${i}0&as_sdt=0%252C5&q=$searchquery" > /tmp/sch_sh/sci_sh_test_${searchquery}${unix_millis}${i}.html
sed -i 's/>/>\n/g' /tmp/sch_sh/sci_sh_test_${searchquery}${unix_millis}${i}.html
done
firefox $(cat /tmp/sch_sh/sci_sh_test_${searchquery}${unix_millis}*.html  | grep href | grep -v accounts.google | grep -e pdf -e html| awk -F "\"" '{print $2}' | uniq)
