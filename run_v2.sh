set -x
rm pois.p*tsv near_dups_v2.p*out connected_components.out result.csv
./split_based_on_places.rb < pois.tsv
cut -f2 pois.tsv | ./generate_tokens_freq_lookup.rb
cat pois.p0.tsv | ./near_dups_v2.rb > near_dups_v2.p0.out &
cat pois.p1.tsv | ./near_dups_v2.rb > near_dups_v2.p1.out &
cat pois.p2.tsv | ./near_dups_v2.rb > near_dups_v2.p2.out &
cat pois.p3.tsv | ./near_dups_v2.rb > near_dups_v2.p3.out &
wait
cat near_dups_v2.p*.out | ./connected_components.rb > connected_components.out
./reportify.rb
echo "see result.csv"
