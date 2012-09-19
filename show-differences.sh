# bash script that shows the evolution of the list defined by the UE's Council Common Position 2001/931/CFSP
# Decisions are published regularly to modify the list.
# The goal of this script is to show changes in the list.
# Usage:
# 1) Search the decisions: http://eur-lex.europa.eu/Result.do?arg0=updating+the+list+of+persons%2C+groups+and+entities+subject+to&arg1=&arg2=&titre=titre&chlang=en&RechType=RECH_mot&Submit=Search
# 2) Save each decision web page, for instance 20110131.html 20110718.html ...
# 3) Run this script

for DECISION in `ls 20*.html`
do
  echo "Parsing $DECISION"
  grep TXT_TE $DECISION |\
    sed -e "s/.*GROUPS AND ENTITIES//gi" -e "s/<\/p><p>/\n/g" -e "s/[0-9]*\. \"//g" | \
    sed -e "s/\".*//g" |\
    grep -v "^$" |\
    grep -v TXT_TE |\
    sed -e "s/’/'/" -e "s/′/'/" -e "s/—/–/" |\
    sort > $DECISION.list
done

cat 20*.list | sort -u > all.list

for DECISION in `ls 20*.list`
do
  echo ""
  echo "Difference between all and $DECISION:"
  diff all.list $DECISION
done
