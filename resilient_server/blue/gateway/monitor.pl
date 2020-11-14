#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes;

my $reporting_interval = 1.0; # seconds
my @bytes_this_interval_UDP = (0, 0, 0, 0);
my @packetnum_UDP = (0, 0, 0, 0);
my @bytes_this_interval_TCP = (0, 0, 0, 0);
my @packetnum_TCP = (0, 0, 0, 0);
my @bytes_this_interval_ICMP = (0, 0, 0, 0);
my @packetnum_ICMP = (0, 0, 0, 0);
my @bytes_this_interval_SYN = (0, 0, 0, 0);
my @packetnum_SYN = (0, 0, 0, 0);
my @bytes_this_interval_ACK = (0, 0, 0, 0);
my @packetnum_ACK = (0, 0, 0, 0);
my @bytes_this_interval_other = (0, 0, 0, 0);
my @packetnum_other = (0, 0, 0, 0);
my $start_time = [Time::HiRes::gettimeofday()];

STDOUT->autoflush(1);

while (<>) {
  if (m/10.1.2.2 >/) {
    if (m/ UDP/) {
      if (/ length (\d+):/) {
        $bytes_this_interval_UDP[0] += $1;
        $packetnum_UDP[0] += 1;
      }
    } elsif (m/ ICMP/){
        if (/ length (\d+):/) {
        $bytes_this_interval_ICMP[0] += $1;
        $packetnum_ICMP[0] += 1;
      }
    } elsif (m/ Flags \[S/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_SYN[0] += $1;
        $packetnum_SYN[0] += 1;
      }
    } elsif (m/ Flags \[P/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_TCP[0] += $1;
        $packetnum_TCP[0] += 1;
      }
    }  elsif (m/ Flags \[./) {
        if (/ length (\d+):/) {
        $bytes_this_interval_ACK[0] += $1;
        $packetnum_ACK[0] += 1;
      }
    }else {
      if (/ length (\d+):/) {
        $bytes_this_interval_other[0] += $1;
        $packetnum_other[0] += 1;
      }
    }
  } elsif (m/10.1.3.2 >/) {
    if (m/ UDP/) {
      if (/ length (\d+):/) {
        $bytes_this_interval_UDP[1] += $1;
        $packetnum_UDP[1] += 1;
      }
    } elsif (m/ ICMP/){
        if (/ length (\d+):/) {
        $bytes_this_interval_ICMP[1] += $1;
        $packetnum_ICMP[1] += 1;
      }
    } elsif (m/ Flags \[S/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_SYN[1] += $1;
        $packetnum_SYN[1] += 1;
      }
    } elsif (m/ Flags \[P/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_TCP[1] += $1;
        $packetnum_TCP[1] += 1;
      }
    }  elsif (m/ Flags \[./) {
        if (/ length (\d+):/) {
        $bytes_this_interval_ACK[1] += $1;
        $packetnum_ACK[1] += 1;
      }
    }else {
      if (/ length (\d+):/) {
        $bytes_this_interval_other[1] += $1;
        $packetnum_other[1] += 1;
      }
    }
  } elsif (m/10.1.4.2 >/) {
    if (m/ UDP/) {
      if (/ length (\d+):/) {
        $bytes_this_interval_UDP[2] += $1;
        $packetnum_UDP[2] += 1;
      }
    } elsif (m/ ICMP/){
        if (/ length (\d+):/) {
        $bytes_this_interval_ICMP[2] += $1;
        $packetnum_ICMP[2] += 1;
      }
    } elsif (m/ Flags \[S/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_SYN[2] += $1;
        $packetnum_SYN[2] += 1;
      }
    } elsif (m/ Flags \[P/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_TCP[2] += $1;
        $packetnum_TCP[2] += 1;
      }
    }  elsif (m/ Flags \[./) {
        if (/ length (\d+):/) {
        $bytes_this_interval_ACK[2] += $1;
        $packetnum_ACK[2] += 1;
      }
    }else {
      if (/ length (\d+):/) {
        $bytes_this_interval_other[2] += $1;
        $packetnum_other[2] += 1;
      }
    }
  } else {
    if (m/ UDP/) {
      if (/ length (\d+):/) {
        $bytes_this_interval_UDP[3] += $1;
        $packetnum_UDP[3] += 1;
      }
    } elsif (m/ ICMP/){
        if (/ length (\d+):/) {
        $bytes_this_interval_ICMP[3] += $1;
        $packetnum_ICMP[3] += 1;
      }
    } elsif (m/ Flags \[S/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_SYN[3] += $1;
        $packetnum_SYN[3] += 1;
      }
    } elsif (m/ Flags \[P/) {
        if (/ length (\d+):/) {
        $bytes_this_interval_TCP[3] += $1;
        $packetnum_TCP[3] += 1;
      }
    }  elsif (m/ Flags \[./) {
        if (/ length (\d+):/) {
        $bytes_this_interval_ACK[3] += $1;
        $packetnum_ACK[3] += 1;
      }
    }else {
      if (/ length (\d+):/) {
        $bytes_this_interval_other[3] += $1;
        $packetnum_other[3] += 1;
      }
    }
  }
  my $elapsed_seconds = Time::HiRes::tv_interval($start_time);
  if ($elapsed_seconds > $reporting_interval) {
    printf "%02d:%02d:%02d \n
          |                 10.1.2.2                 |                 10.1.3.2                 |                 10.1.4.2                 |                   Other                  |\n
    TCP   | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes |\n 
    SYN   | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes |\n  
    ACK   | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes |\n
    UDP   | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes |\n
    ICMP  | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes |\n
    Other | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes | %10d packets %15d Bytes |\n\n",
     (localtime())[2,1,0],
     $packetnum_TCP[0],$bytes_this_interval_TCP[0],$packetnum_TCP[1],$bytes_this_interval_TCP[1],$packetnum_TCP[2],$bytes_this_interval_TCP[2],$packetnum_TCP[3],$bytes_this_interval_TCP[3],
     $packetnum_SYN[0],$bytes_this_interval_SYN[0],$packetnum_SYN[1],$bytes_this_interval_SYN[1],$packetnum_SYN[2],$bytes_this_interval_SYN[2],$packetnum_SYN[3],$bytes_this_interval_SYN[3],
     $packetnum_ACK[0],$bytes_this_interval_ACK[0],$packetnum_ACK[1],$bytes_this_interval_ACK[1],$packetnum_ACK[2],$bytes_this_interval_ACK[2],$packetnum_ACK[3],$bytes_this_interval_ACK[3],
     $packetnum_UDP[0],$bytes_this_interval_UDP[0],$packetnum_UDP[1],$bytes_this_interval_UDP[1],$packetnum_UDP[2],$bytes_this_interval_UDP[2],$packetnum_UDP[3],$bytes_this_interval_UDP[3],
     $packetnum_ICMP[0],$bytes_this_interval_ICMP[0],$packetnum_ICMP[1],$bytes_this_interval_ICMP[1],$packetnum_ICMP[2],$bytes_this_interval_ICMP[2],$packetnum_ICMP[3],$bytes_this_interval_ICMP[3],
     $packetnum_other[0],$bytes_this_interval_other[0],$packetnum_other[1],$bytes_this_interval_other[1],$packetnum_other[2],$bytes_this_interval_other[2],$packetnum_other[3],$bytes_this_interval_other[3];
    $start_time = [Time::HiRes::gettimeofday()];
    @bytes_this_interval_UDP = (0, 0, 0, 0);
    @packetnum_UDP = (0, 0, 0, 0);
    @bytes_this_interval_TCP = (0, 0, 0, 0);
    @packetnum_TCP = (0, 0, 0, 0);
    @bytes_this_interval_ICMP = (0, 0, 0, 0);
    @packetnum_ICMP = (0, 0, 0, 0);
    @bytes_this_interval_SYN = (0, 0, 0, 0);
    @packetnum_SYN = (0, 0, 0, 0);
    @bytes_this_interval_ACK = (0, 0, 0, 0);
    @packetnum_ACK = (0, 0, 0, 0);
    @bytes_this_interval_other = (0, 0, 0, 0);
    @packetnum_other = (0, 0, 0, 0);
  }
}
