# NAME

Telegram::BotKit - Set of Perl classes for creation of interactive and dynamic Telegram bots. Now bots can only process text, but work in progress :)

# VERSION

version 0.01

# KEY FEATURES

- 1.State machine in JSON file

    Allows to create a simple bots for house even for housewife

- 2.Support of dymanic screens

    screen = text \[and/or\] image \[and/or\] document \[and/or\] voice \[and/or\] location \[and/or\] reply markup

- 3. independent and prev msg dependent screens

    Screens can be shown just according sequence in JSON or can depends on previous user reply (callback\_msg property)

- 4.Data validation

    Bot can automatically control is last user reply valid and show pre-defined message if reply is not valid

- 5.Smart serialization

    At last screen bot is calling some perl function that uses some external API.

    Bot store sequence of user inputs and can process data before calling serialize function

- 6.Auto 'Go back' key

    For convenience

    &#x3d; back

# STATE DIAGRAM

# CONFIGURATION EXAMPLE 

Here is example of simple booking bot

# AUTHOR

Pavel Serikov <pavelsr@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Pavel Serikov.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 45:

    You forgot a '=back' before '=head1'

- Around line 91:

    '=end' without a target? (Should be "=end javascript")
