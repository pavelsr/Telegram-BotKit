package Telegram::BotKit::UpdateParser;

# ABSTRACT: Module for parsing Telegram Update object. Resolve issue of getting text from inline or regular keyboard

=head1 SYNOPSIS

    use Telegram::BotKit::UpdateParser qw(get_text get_chat_id);

	my $text = get_text($update);
	my $chat_id = get_chat_id($update);

=cut


use common::sense;

use Exporter qw(import);
our @EXPORT_OK = qw(get_text get_chat_id);


sub _parse {
	my $update = shift;
	if ($update->{message}{text}) {
		return { data => $update->{message}{text}, chat_id => $update->{message}{chat}{id} };
	}
	if ($update->{callback_query}{data}) {
		return { data => $update->{callback_query}{data}, chat_id => $update->{callback_query}{message}{chat}{id} };
	}
}

=method get_text

Get message text from L<Update object|https://core.telegram.org/bots/api/#update>

=cut

sub get_text {
	my $update = shift;
	_parse($update)->{data};
}


=method get_chat_id

Get chat_id from L<Update object|https://core.telegram.org/bots/api/#update>

=cut

sub get_chat_id {
	my $update = shift;
	_parse($update)->{chat_id};
}

1;

