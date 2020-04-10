<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:call-template name="deadlock">
            <xsl:with-param name="maze" as="node()" select="/"/>
        </xsl:call-template>
    </xsl:template>

    <!-- pour toute case simple ou porte qui se trouve dans une impasse, c'est-à-dire entourée par 3 murs, on la remplace par un mur -->
    <!-- On recommence tant que l'on modifie le labyrinthe -->
    <xsl:template name="deadlock">
        <xsl:param name="maze"/>
        
        <xsl:variable name="new-maze">
            <maze>
                <xsl:for-each select="$maze//line">
                    <line>
                        <xsl:for-each select="cell">
                            <cell>
                                <xsl:choose>
                                    <xsl:when test="text()='.' or lower-case(text()) != text()">
                                        <xsl:variable name="position" select="position()"/>
                                        <xsl:variable name="walls-around" select="(if (preceding-sibling::cell[1] = '#') then 1 else 0) 
                                                                                + (if (following-sibling::cell[1] = '#') then 1 else 0)
                                                   + (if (parent::line/preceding-sibling::line[1]/cell[$position] = '#') then 1 else 0)
                                                   + (if (parent::line/following-sibling::line[1]/cell[$position] = '#') then 1 else 0)"/>
                                        <xsl:choose>
                                            <xsl:when test="$walls-around &gt;= 3">
                                                <xsl:value-of select="'#'"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="text()"/>        
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="text()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </cell>
                        </xsl:for-each>
                    </line>
                </xsl:for-each>
            </maze>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$new-maze = $maze">
                <xsl:copy-of select="$new-maze"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="deadlock">
                    <xsl:with-param name="maze" as="node()" select="$new-maze"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>