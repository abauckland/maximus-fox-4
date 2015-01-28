    SUBDOMAIN_REGEXP = /\A[a-z\-]+\z/
    NAME_REGEXP = /\A[a-zA-Z\-]+\z/ #letters, and hyphen only
    COMPANY_NAME_REGEXP = /\A[a-zA-Z0-9\-\s]+\z/ #letters, numbers, hyphen and space only
    POSTCODE_REGEXP = /\A([a-zA-Z0-9\s]{6,8})\z/ #checks format only not validity of the postcode, UK postcode formatting only
    PHONE_REGEXP = /\A^([0]{1})([0-9\s]{8,12})\z/ #must start with '0', can have upto 2 spaces
    REG_REGEXP = /((^([SC]{2}[0-9]{6})$)|([0-9]{8})$)/ #no spaces allowed, 'SC' prefix where used must be capitals
    ADDRESS_REGEXP = /\A[a-zA-Z0-9\-\s]+\z/ #letters, numbers, hyphen and space only  
    CITY_REGEXP = /\A[a-zA-Z\-\s]+\z/ #letters, hyphen and space only
    EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
    VAT_REGEXP = /\A([GB])*([0-9]{9})\z/ #no spaces allowed, inclusion of 'GB' prefix optional, where prefix is provided must be capitals
    DATE_REGEXP = /(20[0-9][0-9])\S((02\S[012][0-9])|(0[469]\S([012][0-9]|30))|(0[13578]\S([012][0-9]|3[0-1]))|(1[012]\S([012][0-9]|3[0-1])))/
    IMAGE_REGEXP = /\A[a-zA-Z\S]+\z/#/\A[a-zA-Z0-9\W]+\z/#
    TIME_REGEXP = /([0-1][0-9]|2[0-3]):[0-5][0-9]/ #format - HH:MM, 24 hours clock only
#    COLOUR_REGEXP = /\A#{1}(\h{6}|\h{3})\z/ #check for 6 or 3 character hex code
    COLOUR_REGEXP = /(?<=#)(?<!^)(\h{6}|\h{3})/ #check for 6 or 3 character hex code