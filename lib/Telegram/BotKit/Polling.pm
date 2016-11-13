package Telegram::BotKit::Polling;

# ABSTRACT: Implementation of Telegram getUpdates method (long polling).  For easy testing your bot code locally

=head1 SYNOPSIS

	use Telegram::BotKit::Polling qw(get_last_messages);
	my $api = WWW::Telegram::BotAPI->new(token => 'token');
    Mojo::IOLoop->recurring(1 => sub {
		my $hash = get_last_messages($api); # or just post '/' => sub
		while ( my ($chat_id, $update) = each(%$hash) ) {
			...
		}
	});

=cut

use WWW::Telegram::BotAPI;
use List::MoreUtils qw/uniq/;
use common::sense;

use Exporter qw(import);
our @EXPORT_OK = qw(get_last_messages);


=method get_last_messages

Return last Update for each chat_id if it such Update exists

Technically it returns a hash where keys = chat_id, values = Update object

=cut

sub get_last_messages {
	my $api = shift;
	my @buffer = @{$api->getUpdates()->{result}};

	if (@buffer) {
		my $h = {};
		my $last_update = {};

		# 1. get unique chat ids
		my @chat_ids;
		for (@buffer) {
			push @chat_ids, $_->{'message'}->{'chat'}->{'id'};
		}
		@chat_ids = uniq @chat_ids;

		# 2. get last message from each chat (assuming that it's sorted by Telegram)
		for my $id (@chat_ids) {
			my @i = grep { $_->{'message'}->{'chat'}->{'id'} eq $id } @buffer;
			$h->{$id} = pop @i;  # last message with higher message_id and update_id
		}

		# 3. Clean buffer on server
		my $last_update = pop @buffer;
		$api->getUpdates({ offset => $last_update->{update_id} + 1.0 })->{result};   # clean buffer on server
		return $h;
	}
	
	return undef;
};

1;