<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:template match="/">
        <distances>
            <xsl:apply-templates select="/distances/cell"/>
        </distances>
    </xsl:template>

    <xsl:template match="cell">
        
        <!-- On supprime les 5 cases centrales -->
        <xsl:if test="@line != 41 and (@column != 41 or @line &lt; 40 or @line &gt; 42)">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="cell"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>