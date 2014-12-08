Name: hello 
Version: 0.1
Release: 1%{?dist}
Summary: Hello A Demo of packaging

URL: https://localhost    
Source0: %{name}-%{version}.tar.gz

License: Internal Use Only

BuildArch: noarch
Requires: bash

%description
This is a demo of packaging

%prep
%setup -n %{name}


%build
%install
rm -r -f %{buildroot}
mkdir -p %{buildroot}/opt/hello
mv hello %{buildroot}/opt/hello

%clean
rm -r -f %{buildroot}

%preun
if [ "$1" == "0" ]; then
    #complete removal   
elif [ "$1" = "1" ]; then
  echo ""
fi

%postun
if [ "$1" = "0" ]; then
    #complete removal
    if [ -d /opt/hello ]; then
      rm -r -f /opt/hello
    fi
fi

%files
/opt/hello/hello

%changelog
* Fri Dec 07 2014 Dave Behnke <dbehnke74@gmail.com> - 0.1-1 
- First Package
