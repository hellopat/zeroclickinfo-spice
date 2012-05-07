package DDG::Spice::NPM;
# ABSTRACT: Gets node package manager search results
use DDG::Spice;

triggers start => "npm";

#spice to => 'http://search.npmjs.org/_list/search/search?startkey="$1"&limit=1';

sub nginx_conf {
    return <<"__END_OF_CONF__";

location ^~ /js/spice/npm/ {
    echo_before_body 'ddg_spice_npm(';
    rewrite ^/js/spice/npm/(.*) /_list/search/search?startkey="\$1"&limit=1 break;
    proxy_pass http://search.npmjs.org/;
    echo_after_body ');';
}

__END_OF_CONF__
}

handle remainder => sub {
    my $term = $_ || '';
    return $term if $term;
    return;
};

1;