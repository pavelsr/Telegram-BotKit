package Telegram::BotKit::Keyboards;

# ABSTRACT: Easy creation of keyboards for Telegram bots

=head1 SYNOPSIS

    use Telegram::Keyboards qw(create_one_time_keyboard create_inline_keyboard);

	my $api = WWW::Telegram::BotAPI->new(token => 'my_token');

	$api->sendMessage ({
	    chat_id      => 123456,
	    text => 'This is a regular keyboard',
	    reply_markup => create_one_time_keyboard(['Button1','Button2'])
	});

	$api->sendMessage ({
	    chat_id      => 123456,
	    text => 'This is a regular keyboard',
	    reply_markup => create_inline_keyboard(['Button1','Button2'], 2)
	});

=cut

use JSON::MaybeXS;
use common::sense;

use Exporter qw(import);
our @EXPORT_OK = qw(create_one_time_keyboard create_inline_keyboard parse_reply_markup available_keys);

my $is_inline_flag = 0;   # 1 = inline / 0 = one item at column


=method create_one_time_keyboard

Create a regular one time keyboard. 
For using with (L<reply_markup|https://core.telegram.org/bots/api/#sendmessage>) 
param of API sendMessage method

my $api = WWW::Telegram::BotAPI->new (
    token => 'my_token'
);

# $keyboard = create_one_time_keyboard($arrayref, $max_keys_per_row);
$keyboard = create_one_time_keyboard(['Button1', 'Button2', 'Button3'], 2);

$api->sendMessage ({
    chat_id      => 123456,
    reply_markup => $keyboard
});

=cut


sub create_one_time_keyboard {
	my ($keys, $k_per_row) = @_;
	if (!(defined $k_per_row)) { 
		if ($is_inline) { $k_per_row = scalar @$keys } else { $k_per_row = 1 };
	}

	my @keyboard;
	my @row;
	for my $i (1 .. scalar @$keys) { 
		my $el = $keys->[$i-1];
		push @row, $el;
		if ((($i % $k_per_row) == 0) || ($i == scalar @$keys)) {
			push (@keyboard, [ @row ]);
			@row=();
		}
	}

	my %rpl_markup = (
		keyboard => \@keyboard,
		one_time_keyboard => JSON::MaybeXS::JSON->true
		);
	return JSON::MaybeXS::encode_json(\%rpl_markup);
}

=method create_inline_keyboard

Create an INLINE keyboard. 
For using with (L<reply_markup|https://core.telegram.org/bots/api/#sendmessage>) 
param of API sendMessage method

my $api = WWW::Telegram::BotAPI->new (
    token => 'my_token'
);

# $keyboard = create_one_time_keyboard($arrayref, $max_keys_per_row);
$keyboard = create_one_time_keyboard(['Button1', 'Button2', 'Button3'], 2);

$api->sendMessage ({
    chat_id      => 123456,
    reply_markup => $keyboard
});

=cut

sub create_inline_keyboard {
	my ($keys, $k_per_row) = @_;
	if (!(defined $k_per_row)) { 
		if ($is_inline) { $k_per_row = scalar @$keys } else { $k_per_row = 1 };
	}
	my @keyboard;
	my @row;
	for my $i (1 .. scalar @$keys) { 
		my $el = $keys->[$i-1];
		push @row, { "text" => $el, "callback_data" => $el };
		if ((($i % $k_per_row) == 0) || ($i == scalar @$keys)) {
			push (@keyboard, [ @row ]);
			@row=();
		}
	}
	my %rpl_markup = (
		inline_keyboard  => \@keyboard
	);
	return JSON::MaybeXS::encode_json(\%rpl_markup);
}


=method available_keys

Helper function for tg-botkit simulator. 
Return string of possible answers in L<Backus–Naur notation|https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form>

print Dumper available_keys(['B1', 'B2', 'B3' ]) #  '[ B1 | B2 | B3 ]'

=cut

sub available_keys {
	my $arr = shift;
	my $text = '[ ';
	$text.= join(' | ',@$arr);
	$text.= ' ]';
	return $text;
}

=head2 parse_reply_markup

Helper function for tg-botkit simulator. 
Function opposite to create_inline_keyboard and create_one_time_keyboard
Transform $reply_markup JSON object into perl array

=cut

sub parse_reply_markup {
	my $reply_markup = shift;
	my $data_structure = decode_json($reply_markup);
	my @res;
	my @keyboard;
	my $is_inline_flag = 0;

	if (defined $data_structure->{inline_keyboard}) {
		@keyboard = {$data_structure->{inline_keyboard}};
		$is_inline_flag = 1;
	} elsif (defined $data_structure->{keyboard}) {
		@keyboard = @{$data_structure->{keyboard}};
	} else {
		warn "reply_markup structure isn't recognized";
		return undef;
	}

	for my $i (@keyboard) {
		for (@$i) {
			if ($is_inline_flag) {
				push @res, $_->{text};
			} else {
				push @res, $_;
			}
		}
	}

	return \@res;
}



1;


=head1 TODO

=head2 build_optimal()

build keyboard with optimalrows and columns based on keyboard content

=head2 build_optimal_according_order()

build keyboard with optimal rows and columns based on keyboard content
WITHOUT changing buttons order

= cut
