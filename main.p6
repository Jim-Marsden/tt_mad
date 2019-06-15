#!/usr/bin/env perl6
#use my_lib;

sub generate_verbs($story, $sign, $new_thing)
{
    my $rv = $story;
    loop {
        if $rv !~~ s/$sign/$new_thing/
        {last;}
        
    }
    return $rv;
}

sub find_mdl()
{
    my @mdl_files;
    for dir() -> $file {
	if $file.Str().ends-with('.mdl')
        {
            @mdl_files.push($file.Str())
        }
    }
    
    return @mdl_files;
}

sub generate_hash_mdl(Str $file_name)
{
    

    sub parse_hash(Str $str) {
        my $rv = $str;
        my %hash_rv;
        if $rv.contains('{')
        {

            my $rv_bracket_index = $rv.index('{');
            $rv.=substr($rv_bracket_index + 1);
        }

        if $rv.contains('}')
        {
            my $rv_bracket_index = $rv.rindex('}');
            $rv.=substr(0, $rv_bracket_index);
        }

        while $rv.contains(", ")
        {
            my $rv_comma_index = $rv.index(", ");
            my $temp_str = $rv.substr(0, $rv_comma_index);
            $rv.=substr($rv_comma_index + 1);
            
            %hash_rv{$temp_str} = "Nil";

            say  $temp_str;
            
        }
	if $rv.chars > 0
	{
		%hash_rv{$rv} = "Nil";
	}

        return %hash_rv;

        #say $rv;

    }
    my $fh = open "$file_name", :r;
    my $contents = $fh.slurp;
    $fh.close;

    my @match =  $contents ~~ m/ \{ .+ \} / ;
    if @match # > 0
    {
        return parse_hash(@match[0].Str);
    }
    else 
    {
        return Nil;
    }
    
    
}

sub get_story_body(Str $file_name)
{
my $fh = open "$file_name", :r;
    my $contents = $fh.slurp;
    $fh.close;

    my $rv = $contents;

    my @match =  $contents ~~ m/ \< .+ \> / ;
    if @match # > 0
    {
        if $rv.contains('<')
        {

            my $rv_bracket_index = $rv.index('{');
            $rv.=substr($rv_bracket_index + 1);
        }

        if $rv.contains('>')
        {
            my $rv_bracket_index = $rv.rindex('}');
            $rv.=substr(0, $rv_bracket_index);
        }

        return $rv;
    }
    else
    {
        return Nil;
    }
}

sub MAIN()
{

   my %hash_array = generate_hash_mdl (find_mdl()[0]);

    my $test = get_story_body (find_mdl()[0]);
    my $test2 :=
Q"There was someone named name1 who was an animal1. name1 was really quite adj1 and adj2.
The animal1 was verb1 in the place1. Until one day they verb2 and then name1 were never
seen agin because the noun1.";

    loop
    {

        my $story = $test;
        for keys %hash_array -> $name {
            %hash_array{$name} = prompt "please give me a(n)$name: ";
            $story = generate_verbs($story, $name, %hash_array{$name});

        }
        put $story;
        state $do_again = prompt "Do again(y/n)";

        if $do_again eq "n" {last;}

    }
}
