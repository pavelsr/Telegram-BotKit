package Telegram::BotKit::Sessions;

# ABSTRACT: Implements memory of Telegram::BotKit::Wizard state automat. Almost all methods has at least one argument = chat_id

use common::sense;

=head1 SYNOPSIS

	my $sess = Telegram::BotKit::Sessions->new();
	$sess->start(12345); # 12345 = chat_id

=cut


=method new

Create a new session object.

Keys will be chat_id and values = array of Update objects (or its particular fields)

=cut


sub new {
    my $class = shift;
    my $sess_obj = {};
    $sess_obj->{session} = {};
    bless $sess_obj, $class;
    return $sess_obj;
}


=method all

Return all session for specified chat_id

$session->all($chat_id);

=cut

sub all {
	my ($self, $chat_id) = @_;
	if ($chat_id) {
		if (defined $self->{session}{$chat_id}) {
			return $self->{session}{$chat_id};
		} else {
			return undef;
		}
	} else {
		return $self->{session};
	}
}

=method all_keys_arr

Return array contains from all messages of session with particular chatId and $key

Can be useful while data serialization

$session->all_keys_arr($chat_id, 'some_key');  # ['Value 1', 'Value 2']

=cut


sub all_keys_arr {
	my ($self, $chat_id, $key) = @_;
	my @msgs;
	for (@{$self->{session}{$chat_id}}) {
		push @msgs, $_->{$key};
	}
	return \@msgs;
}

=method start

Start session for particular chat_id

$session->start($chat_id);

=cut

sub start {
    my ($self, $chat_id) = @_;
   	$self->{session}{$chat_id} = [];
}


=method del

Delete session for particular chat_id

$session->del($chat_id);

=cut

sub del {
    my ($self, $chat_id) = @_;
    delete $self->{session}{$chat_id};
}

=method set

Method for inserting any data into session

Mainly intended for unit testing, also can be used for data serialization

$session->set($chat_id, $array);

=cut


sub set {
   my ($self, $chat_id, $array) = @_;
   $self->{session}{$chat_id} = $array;
}


=method update

Update session for particular chat_id

$session->update($chat_id, $data_to_store_in_session);

=cut


sub update {
	my ($self, $chat_id, $hash_with_data) = @_;
	my @active_sess_uids = keys %{$self->{session}};

	if ((grep  { $chat_id eq $_ } @active_sess_uids)) {
		push @{$self->{session}->{$chat_id}}, $hash_with_data;
	}

	return $self->{session}->{$chat_id};
}

=method last

Return last element of session for particular chat_id

$session->last($chat_id);

=cut


sub last {
	my ($self, $chat_id) = @_;
	if ($self->{session}{$chat_id}) { 
		my @sess_for_chat = @{$self->{session}{$chat_id}}; 
		return $sess_for_chat[$#sess_for_chat];   # last elenemt
	} else {
		return undef;
	}
}

=method combine_properties

Return hash that combines two properies of session

=cut

sub combine_properties {
	my ($self, $chat_id, $params) = @_;
	my $kv = {};
	for (@{$self->{session}{$chat_id}}) {
		$kv->{$_->{$params->{first_property}}} = $_->{$params->{second_property}};
	}
	my $returned_hash;
	$returned_hash->{$params->{name_of_hash_key}} = $kv;
	return $returned_hash;
}

=method combine_properties_retrospective

Return hash that combines two properies of session from specified and previous screens 

=cut

sub combine_properties_retrospective {
	my ($self, $chat_id, $params) = @_;
	my $kv = {};
	my @sess = @{$self->{session}{$chat_id}};

	for my $i (0 .. $#sess-1) {
		my $key = $sess[$i]->{$params->{first_property}};
		my $value = $sess[$i+1]->{$params->{second_property}};
		$kv->{$key} = $value;
	}

	my $returned_hash;
	$returned_hash->{$params->{name_of_hash_key}} = $kv;
	return $returned_hash;
}

=method get_replies_hash

specific usage of combine_properties_retrospective()

Combine "screen" property from i session element and "callback_text" from i+1 session element

=cut

sub get_replies_hash {
	my ($self, $chat_id) = @_;
	my $params = { 
		name_of_hash_key => 'replies', 
		first_property => 'screen',
		second_property => 'callback_text'
	};
	my $res = $self->combine_properties_retrospective($chat_id,$params);
	return $res;
}

1;