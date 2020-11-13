#!/usr/bin/awk -f

BEGIN {
  # Set the input and output separator
  FS=":"
  OFS=":"
  # Set the counter to zero
  account=0
}
{
  # Second value to zero
  $2=""
  # print $0
  account++
}
END {
  print account " accounts.\n"
}