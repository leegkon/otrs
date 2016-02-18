# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SupportDataCollector::Plugin::Database::OutdatedTables;

use strict;
use warnings;

use base qw(Kernel::System::SupportDataCollector::PluginBase);

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::System::DB',
);

sub GetDisplayPath {
    return Translatable('Database');
}

sub Run {
    my $Self = shift;

    my %ExistingTables = map { lc($_) => 1 } $Kernel::OM->Get('Kernel::System::DB')->ListTables();

    my @OutdatedTables;

    if ( $ExistingTables{notifications} ) {
        push @OutdatedTables, 'notifications';
    }

    if ( !@OutdatedTables ) {
        $Self->AddResultOk(
            Label => Translatable('Outdated Tables'),
            Value => '',
        );
    }
    else {
        $Self->AddResultWarning(
            Label   => Translatable('Outdated Tables'),
            Value   => join( ', ', @OutdatedTables ),
            Message => Translatable("Outdated tables were found in the database. These can be removed if empty."),
        );
    }

    return $Self->GetResults();
}

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
