# NAME

Telegram::BotKit::Wizard - State automat for Telegram Bots

# VERSION

version 0.01

# SYNOPSIS

my $wizard = Telegram::BotKit::Wizard->new({ 
	screens\_arrayref => \[{},{}, ... , {}\], 
	dyn\_kbs\_class=>'Test::Class',
	serialize\_func => \\&test\_func(), # not implemented now
	keyboard\_type => 'inline'  # regular by default,
	default\_welcome\_msg => '', # message to show if there is no 'welcome\_msg' attr at screen
	debug => 1
)};

my $msg = $w->process($update);
$api->sendMessage($msg);  # my $api = WWW::Telegram::BotAPI->new(token => '');

# METHODS

## defaults

Set defaults for non-obligatory parameters

## get\_screen

Get screen depending on was /start cmd sent or previous screen in session

## build\_keyboard\_array 

Create an array for keyboard

Works both with static or dynamic screens

## build\_msg

Build message depending on $screen, $chat\_id and $callback\_msg

$self->build\_msg($screen, $chat\_id, $text)

## update\_session

Correct update of session.
Here you can see which parameters of screen to save

## process

Main public subroutine.
Process Update object and return msg for 
[sendMessage](https://core.telegram.org/bots/api/#sendmessage) 
method

# AUTHOR

Pavel Serikov <pavelsr@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Pavel Serikov.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
