Name:			ndppd
Version:	%{?pkg_version}
Release:	1%{?dist}
Summary:	NDP Proxy Daemon

Group:		NetUtils
License:	GPLv3
URL:			https://github.com/DanielAdolfsson/ndppd.git
Source0:	ndppd.tgz
#Source0:	

BuildRequires: systemd
#Requires:	

%description
NDP Proxy Daemon

%prep
%setup -q


%build
make PREFIX=/usr %{?_smp_mflags}


%install
make PREFIX=/usr install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%{_sbindir}/ndppd
%{_unitdir}/ndppd.service

%config
%{_sysconfdir}/ndppd.conf

%doc
%{_mandir}/man1/ndppd.1.gz
%{_mandir}/man5/ndppd.conf.5.gz

%changelog
* Thu Mar 08 2018 Sudhagar Chinnaswamy 	0.2.5
	- Initial rpm release