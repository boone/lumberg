module Lumberg
  module Cpanel
    class Email < Base
      # Public: Get info about how the main email account handles
      # undeliverable mail.
      #
      # options - Hash options for API call params (default: {}).
      #
      # Returns Hash API response.
      def main_discard(options = {})
        perform_request(
          :api_function => "checkmaindiscard"
        )
      end

      # Public: Add a forwarder.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain    - String forwarder domain.
      #   :email     - String local part ("user" if "user@domain.com").
      #   :fwdopt    - String type of forwarder. Accepted values:
      #                "pipe", "fwd", "system", "blackhole", "fail"
      #   :fwdemail  - String Destination email address.
      #   :fwdsystem - String system account to forward to (optional). Should
      #                only be used if :fwdopt is set to "system".
      #   :failmsgs  - String failure message (optional). Only used if "fwdopt"
      #                is set to "fail".
      #   :pipefwd -   String path to program to pipe to (optional). Only used
      #                if "fwdopt" is set to "pipe"
      #
      # Returns Hash API response.
      def add_forwarder(options = {})
        perform_request({
          :api_function => "addforward"
        }.merge(options))
      end

      # Public: Get list of forwarders.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String domain for which to retrieve forwarders (optional).
      #   :regex  - String regular expression to filter results (optional).
      #
      # Returns Hash API response.
      def forwarders(options = {})
        perform_request({
          :api_function => "listforwards"
        }.merge(options))
      end

      # Public: Retrieve a list of domains that use aliases and custom
      # catch-all addresses.
      #
      # options - Hash options for API call params (default: {}).
      #
      # Returns Hash API response.
      def domains_with_aliases(options = {})
        perform_request(
          :api_function => "listaliasbackups"
        )
      end

      # Public: Add a mailing list. Uses API1 because API2 doesn't provide
      # an equivalent method.
      #
      # options - Hash options for API call params (default: {}):
      #   :list     - String mailing liist name.
      #   :password - String mailing list password.
      #   :domain   - String mailing list domain.
      #
      # Returns Hash API response.
      def add_mailing_list(options = {})
        perform_request({
          :api_function => "addlist",
          :api_version  => 1,
          "arg-0"       => options[:list],
          "arg-1"       => options[:password],
          "arg-2"       => options[:domain]
        })
      end

      # Public: Get list Mailman mailing lists.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String domain for which to retrieve mailing lists
      #             (optional).
      #   :regex  - String regular expression to filter results (optional).
      #
      # Returns Hash API response.
      def mailing_lists(options = {})
        perform_request({
          :api_function => "listlists"
        }.merge(options))
      end

      # Public: Get list of domains that can send/receive mail.
      #
      # options - Hash options for API call params (default: {}):
      #   :skipmain - String skip main domain by passing "1" (optional).
      #
      # Returns Hash API response.
      def domains(options = {})
        perform_request({
          :api_function => "listmaildomains"
        }.merge(options))
      end

      # Public: Get list of mail exchanger information.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String domain for which to retrieve mail exchangers.
      #
      # Returns Hash API response.
      def mx(options = {})
        perform_request({
          :api_function => "listmxs"
        }.merge(options))
      end

      # Public: Set mail delivery for a domain.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain   - String domain corresponding to the mail exchanger to set.
      #   :delivery - String status to set for the mail exchanger. Accepted:
      #               "auto", "local", "secondary", "remote".
      #   :user     - String user of the cPanel account whose domain
      #               corresponds to the mail exchanger you with to set.
      #
      # Returns Hash API response.
      def set_mail_delivery(options = {})
        perform_request({
          :api_function => "setalwaysaccept",
          :mxcheck      => options[:delivery]
        }.merge(options))
      end

      # Public: Check cPanel config for local mail delivery setting.
      # This function checks cPanel config, not DNS.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String domain to check. Will return settings for all
      #             domains if omitted.
      #
      # Returns Hash API response.
      def check_local_delivery(options = {})
        perform_request({
          :api_function => "getalwaysaccept"
        }.merge(options))
      end

      # Public: Add a new email filter. See
      # http://docs.cpanel.net/twiki/bin/view/ApiDocs/Api2/ApiEmail#Email::storefilter
      # for gory details.
      #
      # options - Hash options for API call params (default: {}). Options
      #           with * indicate numeric suffix corresponding to filter
      #           number:
      #   :account       - String value. For user-level filters, enter email
      #                    address. Leave empty for account-level filter. Use
      #                    cPanel username for default address filters.
      #   :action*       - String action taken by filter. Accepted: "deliver",
      #                    "fail", "finish", "save", "pipe"
      #   :dest*         - String destination for mail received by the filter.
      #   :filtername    - String name of filter.
      #   :match*        - String filter match type. Accepted: "is", "matches",
      #                    "contains", "does not contain", "begins", "ends",
      #                    "does not begin", "does not end", "does not match",
      #                    "is above" (numeric), "is not above" (numeric),
      #                    "is below" (numeric), "is not below" (numeric)
      #   :opt*          - String value used to connect conditions. Accepted:
      #                    "or", "and".
      #   :part*         - String part of the email to apply the :match option
      #                    to. Accepted: "$header_from:", "$header_subject:",
      #                    "$header_to:", "$reply_address:", "$message_body",
      #                    "$message_headers",
      #                    'foranyaddress $h_to",$h_cc:,$h_bcc:',
      #                    "not delivered", "error_message",
      #                    "$h_X-Spam-Status:",
      #                    "$h_X-Spam-Score:", and "$h_X-Spam-Bar:". The last 3
      #                    options require SpamAssassin to be enabled. You may
      #                    also use "error_message" or "not delivered" which
      #                    do not require the :match parameter.
      #   :val*          - String value to match.
      #   :oldfiltername - String value. Use current filter name here and
      #                    specify new filter name in :filtername option to
      #                    rename filter (optional).
      #
      # Returns Hash API response.
      def add_filter(options = {})
        perform_request({
          :api_function => "storefilter"
        }.merge(options))
      end

      # Public: Get a list of email filters.
      #
      # options - Hash options for API call params (default: {}):
      #   :account   - String value (optional). Lists user-level filters if
      #                email address given. Lists user-level filters
      #                associated with default address if cPanel username
      #                given. Lists account-level filters if omitted.
      #   :old_style - Boolean (optional, default: false). Use deprecated
      #                Email::listfilters.
      #
      # Returns Hash API response.
      def filters(options = {})
        func = options.delete(:old_style) ? "listfilters" : "filterlist"

        perform_request({
          :api_function => func
        }.merge(options))
      end

      # Public: Add a POP account.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain   - String domain for the email account.
      #   :email    - String local part of email address. "user" if
      #               "user@domain".
      #   :password - String password for email account.
      #   :quota    - Integer disk space quota in MB, 0 for unlimited.
      #
      # Returns Hash API response.
      def add_account(options = {})
        perform_request({
          :api_function => "addpop"
        }.merge(options))
      end

      # Public: Get a list of email accounts. Uses the cPanel-preferred
      # API call Email::listpopswithdisk.
      #
      # options - Hash options for API call params (default: {}):
      #  :domain        - String domain for which to retrieve email accounts
      #                   (optional).
      #  :regex         - String regular expression to filter results
      #                   (optional).
      #  :nearquotaonly - String value. Set to "1" to only view accounts that
      #                   have used >= 95% of their quota (optional).
      #  :no_validate   - String vlaue. Set to "1" to only read data from
      #                   account's ".cpanel/email_accounts.yaml" file. This
      #                   parameter is "off" by default, causing the function
      #                   to check the passwd file, quota files, etc.
      #                   (optional).
      #  :style         - Symbol account list style (optional,
      #                   default: :with_disk). Accepted: :with_disk,
      #                   :without_disk, :with_image, :single.
      #
      # Returns Hash API response.
      def accounts(options = {})
        styles = {
          :with_disk    => "listpopswithdisk",
          :without_disk => "listpops",
          :with_image   => "listpopswithimage",
          :single       => "listpopssingle"
        }
        func = styles.fetch(options.delete(:style), styles[:with_disk])

        perform_request({
          :api_function => func
        }.merge(options))
      end

      # Public: Get default address info.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String efault address domain.
      #
      # Returns Hash API response.
      def default_address(options = {})
        perform_request({
          :api_function => "listdefaultaddresses"
        }.merge(options))
      end

      # Public: Get disk usage information for an email account.
      #
      # options - Hash options for API call params (default: {}):
      #   :domain - String value. "domain.com" if "user@domain.com"
      #   :login  - String value. "user" if "user@domain.com".
      #
      # Returns Hash API response.
      def disk_usage(options = {})
        perform_request({
          :api_function => "getdiskusage"
        }.merge(options))
      end

      # Public: Get full path to a mail folder.
      #
      # options - Hash options for API call params (default: {}):
      #   :account - String email address.
      #   :dir     - String mail folder you wish to query for its full path
      #              (optional, default: "mail").
      #
      # Returns Hash API response.
      def mail_dir(options = {})
        perform_request({
          :api_function => "getabsbrowsedir"
        }.merge(options))
      end

      # Public: Retrieve a list of mail dirs.
      #
      # options - Hash options for API call params (default: {}):
      #   :account      - String email account (optional).
      #   :dir          - String mail directories to display (optional).
      #                   "default" or "mail" will list all mail dirs.
      #                   Providing a domain will list dirs related to the
      #                   domain.
      #   :showdotfiles - Boolean view hidden directories?
      #
      # Returns Hash API response.
      def mail_dirs(options = {})
        perform_request({
          :api_function => "browseboxes"
        }.merge(options))
      end
    end
  end
end
