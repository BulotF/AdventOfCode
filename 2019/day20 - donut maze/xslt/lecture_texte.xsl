<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" omit-xml-declaration="yes" indent="no"/>

    <xsl:param name="text-file"/>

    <xsl:template match="/">
        <xsl:variable name="text-content" select="unparsed-text($text-file)"/>
        <maze>
            <xsl:for-each select="tokenize($text-content,'\n')">
                <xsl:variable name="line-content" select="."/>
                <line>
                    <xsl:for-each select="1 to string-length($line-content)">
                        <cell>
                            <xsl:value-of select="substring($line-content,position(),1)"/>
                        </cell>
                    </xsl:for-each>
                </line>
            </xsl:for-each>
        </maze>
    </xsl:template>

</xsl:stylesheet>