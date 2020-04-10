<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    <!-- ceci permet d'importer le template nommé calculate-chemical -->
    <!-- le template "/" est considéré comme non prioritaire par rapport à celui ci-dessous -->
    <xsl:import href="day14-1.xsl"/>
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:param name="depth-file"/>
    
    <xsl:variable name="ore-expected" as="xs:double" select="1000000000000"/>
    
    <xsl:variable name="depth-chemical" select="doc($depth-file)"/>
    <xsl:variable name="root" select="/"/>
    
    <xsl:template match="/">
        <Fuel>
            <xsl:call-template name="find-fuel-quantity">
                <xsl:with-param name="minimum" select="1" as="xs:double"/>
                <xsl:with-param name="maximum"/>
            </xsl:call-template>
        </Fuel>
    </xsl:template>

    <xd:doc>
        <xd:desc>Template en 2 phases :
        - maximum à blanc et minimum qui ne produit pas assez avec minimum = 2^n ; on augmente n de 1 jusqu'à passer à la 2° étape
        - minimum qui ne produit pas assez ; maximum qui produit trop et différence entre les deux égale 2^k ; on diminue k de 1 à chaque étape par dichotomie</xd:desc>
    </xd:doc>
    <xsl:template name="find-fuel-quantity">
        <xsl:param name="minimum" as="xs:double"/>
        <xsl:param name="maximum"/>

        <xsl:choose>
            <xsl:when test="string($maximum) = ''">
                <xsl:variable name="generated-ore">
                    <xsl:call-template name="initialize-chemical">
                        <xsl:with-param name="fuel-quantity" select="$minimum *2" as="xs:double"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$generated-ore &gt; $ore-expected">
                        <xsl:call-template name="find-fuel-quantity">
                            <xsl:with-param name="minimum" select="$minimum"/>
                            <xsl:with-param name="maximum" select="$minimum *2"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="find-fuel-quantity">
                            <xsl:with-param name="minimum" select="$minimum *2"/>
                            <xsl:with-param name="maximum"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="number($maximum) = $minimum +1">
                <xsl:value-of select="$maximum"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="generated-ore">
                    <xsl:call-template name="initialize-chemical">
                        <xsl:with-param name="fuel-quantity" select="($minimum + number($maximum)) div 2" as="xs:double"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$generated-ore &gt; $ore-expected">
                        <xsl:call-template name="find-fuel-quantity">
                            <xsl:with-param name="minimum" select="$minimum"/>
                            <xsl:with-param name="maximum" select="($minimum + number($maximum)) div 2"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="find-fuel-quantity">
                            <xsl:with-param name="minimum" select="($minimum + number($maximum)) div 2"/>
                            <xsl:with-param name="maximum" select="$maximum"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>template destiné à factoriser l'appel au template existant et à modifier la mise en forme de la réponse.
        Aurait pu être utilisé par day14-1 avec le paramètre 1...</xd:desc>
    </xd:doc>
    <xsl:template name="initialize-chemical">
        <xsl:param name="fuel-quantity" as="xs:double"/>
        
        <xsl:variable name="chemical-tree">
            <xsl:call-template name="calculate-chemical">
                <xsl:with-param name="depth" select="1"/>
                <xsl:with-param name="chemicals" as="node()">
                    <chemicals>
                        <chemical output="ORE" inquantity="0"/>
                        <xsl:for-each select="$root//chemical[parent::chemicals]">
                            <xsl:copy>
                                <xsl:choose>
                                    <xsl:when test="@output='FUEL'">
                                        <xsl:attribute name="inquantity" select="$fuel-quantity"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="inquantity" select="0"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:copy-of select="@* | node()"/>
                            </xsl:copy>
                        </xsl:for-each>
                    </chemicals>
                </xsl:with-param>
            </xsl:call-template>            
        </xsl:variable>
        <xsl:value-of select="$chemical-tree//*/@inquantity"/>
    </xsl:template>
    
</xsl:stylesheet>