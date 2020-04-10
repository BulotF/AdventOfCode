<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

    <xsl:variable name="root" select="/"/>
    <xsl:template match="/">
        <xsl:call-template name="add-letter">
            <xsl:with-param name="route" as="node()">
                <maze>
                    <journey last="@" distance="0" path=""/>
                </maze>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- On a établi la liste des trajets optimum avec un certain nombre de lettres -->
    <!-- identifiant du trajet : liste des lettres + lettre finale ; pour chacun, on stocke le parcours exact (pour regarder) et la distance (car attendu) -->
    <!-- Pour chaque trajet, on calcule l'ensemble des suites possibles avec la distance minimum pour chaque -->
    <!-- On supprime les doublons en prenant l'optimal -->
    
    <!-- on recommence jusqu'à 26 lettres -->
    
    <xsl:template name="add-letter">
        <xsl:param name="route" as="node()"/>
        
        <xsl:variable name="route-with-doubles">
            <maze>
                <xsl:for-each select="$route//journey">
                    <xsl:apply-templates select="$root//distances/cell[@text=current()/@last]">
                        <xsl:with-param name="journey" select="." as="node()"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </maze>
        </xsl:variable>
        <xsl:variable name="route-without-doubles">
            <maze>
                <xsl:for-each select="$route-with-doubles//journey">
                    <!-- seules les keys contiennent du texte -->
                    <xsl:variable name="keys" select="keys" as="node()*"/>
                    <xsl:variable name="last" select="@last"/>
                    <!-- On supprime les doublons en ne gardant que le premier trajet  -->
                    <xsl:if test="not(preceding::journey[@last=$last and not(keys[not(.=$keys)])])">
                        <!-- On prend la distance minimale parmi les routes qui terminent au point courant et ne passent que par des clefs autorisées -->
                        <xsl:variable name="min-distance" select="min($route-with-doubles//journey[@last=$last and not(keys[not(.=$keys)])]/@distance)"/>
                        <journey last="{$last}" distance="{$min-distance}">
                            <xsl:attribute name="path" select="$route-with-doubles//journey[@last=$last and not(keys[not(.=$keys)]) and @distance=$min-distance][1]/@path"/>
                            <xsl:copy-of select="keys"/>
                        </journey>
                    </xsl:if>
                </xsl:for-each>
            </maze>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$route-without-doubles//journey[1]/string-length(@path) = 26">
                <xsl:value-of select="min($route-without-doubles//@distance)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="add-letter">
                    <xsl:with-param name="route" select="$route-without-doubles" as="node()"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="distances/cell">
        <xsl:param name="journey" as="node()"/>
        
        <xsl:variable name="master-letter" select="@text"/>
        
        <!-- On cherche toutes les lettres minuscules, que l'on n'a pas déjà et qui n'ont pas d'ancêtre lettre dont on n'a pas déjà la clef -->
        <xsl:for-each select="descendant::cell[upper-case(@text) != @text
                                           and not(@text = $journey//keys/text())
                                           and not(ancestor::cell[upper-case(@text) != lower-case(@text) 
                                                              and not(lower-case(@text) = $journey//keys/text())])]">
            <xsl:variable name="new-letter" select="@text"/>
            <journey last="{$new-letter}">
                <xsl:attribute name="distance" select="$journey//@distance + sum(ancestor-or-self::cell/@distance)"/>
                <xsl:attribute name="path" select="concat($journey//@path,$new-letter)"/>
                <xsl:for-each select="$journey//keys/text() | $new-letter">
                    <xsl:sort select="." order="ascending"/>
                    <keys><xsl:value-of select="."/></keys>
                </xsl:for-each>
            </journey>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>