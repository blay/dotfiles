# match blank items (items removed from the list), or marked as done
# note that the match is against the second "word"
$2 ~ /^x?$/ {
  done[$1] = $0
  next
}

# match items with priority A marker
$2 ~ /^\([Aa]\)$/ {
  pri_a[$1] = $0
  next
}

# match items with other priority markers
$2 ~ /^\([[:upper:]]\)$/ {
  pri[$1] = $0
  next
}

# match any items not caught above
{
  rest[$1] = $0
}

END {
  # print removed and marked-done items by ascending item number 
  sort_done = "sort -n"
  
  for(line in done) {
    print done[line] | sort_done
  }
  
  close(sort_done)

  # print unmatched items by ascending item number 
  sort_rest = "sort -n"
  
  for(line in rest) {
    print rest[line] | sort_rest
  }
  
  close(sort_rest)

  # print 'A' prioritized items by ascending item number
  sort_pri = "sort -n"

  for(line in pri_a) {
    print pri_a[line] | sort_pri
  }
  
  close(sort_pri)

  # print prioritized items by alphabetic priority
  sort_pri = "sort -f -k2"

  for(line in pri) {
    print pri[line] | sort_pri
  }
  
  close(sort_pri)
}
