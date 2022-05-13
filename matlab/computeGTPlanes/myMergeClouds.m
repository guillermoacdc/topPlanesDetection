function pc=myMergeClouds(pc_set)
pc12=pcmerge(pc_set{1},pc_set{2},0.001);
pc34=pcmerge(pc_set{3},pc_set{4},0.001);
pc=pcmerge(pc12,pc34,0.001);