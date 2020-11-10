#!/bin/sh
TZ=${TZ:-UTC}

F2B_LOG_TARGET=${F2B_LOG_TARGET:-STDOUT}
F2B_LOG_LEVEL=${F2B_LOG_LEVEL:-INFO}
F2B_DB_PURGE_AGE=${F2B_DB_PURGE_AGE:-1d}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Init
echo "Initializing files and folders..."
mkdir -p /f2bdata/db /f2bdata/action.d /f2bdata/filter.d /f2bdata/jail.d
ln -sf /f2bdata/jail.d /etc/fail2ban/

# Fail2ban conf
echo "Setting Fail2ban configuration..."
sed -i "s|logtarget =.*|logtarget = $F2B_LOG_TARGET|g" /etc/fail2ban/fail2ban.conf
sed -i "s/loglevel =.*/loglevel = $F2B_LOG_LEVEL/g" /etc/fail2ban/fail2ban.conf
sed -i "s/dbfile =.*/dbfile = \/f2bdata\/db\/fail2ban\.sqlite3/g" /etc/fail2ban/fail2ban.conf
sed -i "s/dbpurgeage =.*/dbpurgeage = $F2B_DB_PURGE_AGE/g" /etc/fail2ban/fail2ban.conf

# Check custom actions
echo "Checking for custom actions in /f2bdata/action.d..."
actions=$(ls -l /f2bdata/action.d | egrep '^-' | awk '{print $9}')
for action in ${actions}; do
  if [ -f "/etc/fail2ban/action.d/${action}" ]; then
    echo "  WARNING: ${action} already exists and will be overriden"
    rm -f "/etc/fail2ban/action.d/${action}"
  fi
  echo "  Add custom action ${action}..."
  ln -sf "/f2bdata/action.d/${action}" "/etc/fail2ban/action.d/"
done

# Check custom filters
echo "Checking for custom filters in /f2bdata/filter.d..."
filters=$(ls -l /f2bdata/filter.d | egrep '^-' | awk '{print $9}')
for filter in ${filters}; do
  if [ -f "/etc/fail2ban/filter.d/${filter}" ]; then
    echo "  WARNING: ${filter} already exists and will be overriden"
    rm -f "/etc/fail2ban/filter.d/${filter}"
  fi
  echo "  Add custom filter ${filter}..."
  ln -sf "/f2bdata/filter.d/${filter}" "/etc/fail2ban/filter.d/"
done

/usr/bin/fail2ban-server -b -x -v start
/usr/bin/caddy run -config /etc/caddy/Caddyfile
