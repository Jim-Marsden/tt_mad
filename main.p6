#!/usr/bin/env perl6
#use my_lib;

sub generate_verbs($story, $sign, $new_thing)
{
    my $rv = $story;
    loop {
        if $rv ~~ s/$sign/$new_thing/
        {}
        else
        {
            last;
        }
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
    my $fh = open "$file_name", :r;
    my $contents = $fh.slurp;
    $fh.close;

    my @match =  $contents ~~ m/ \{ .+ \} / ;

    my %hhh = Thing => "body";
    #put @match;
    #put +@match;
    return @match, %hhh;
}

sub get_story_body(Str $file_name)
{

}

sub MAIN()
{

    my (@hash_array, %hhh) = generate_hash_mdl (find_mdl()[0]);
    put @hash_array;
    return 0;
    my %hash_array =
            name1=>Nil,
            animal1=>Nil,
            place1=>Nil,
            adj1=>Nil,
            adj2=>Nil,
            noun1=>Nil,
            verb1=>Nil,
            verb2=>Nil,
    ;

    my $test :=
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