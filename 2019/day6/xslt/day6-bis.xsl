<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <planets>
            <xsl:apply-templates select="//orbit[@dot='COM']"/>
        </planets>
    </xsl:template>

    <xsl:template match="orbit">
        <!-- On recopie la planète et on appelle ses enfants avec le même template -->
        <planet name="{@planet}">
            <xsl:apply-templates select="//orbit[@dot=current()/@planet]"/>
        </planet>
    </xsl:template>

</xsl:stylesheet>